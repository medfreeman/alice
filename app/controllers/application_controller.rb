class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :reject_locked!
  before_filter :load_years
  before_filter :load_current_year
  before_filter :load_current_studios
  before_filter :load_categories
  before_filter :masquerade

  def masquerade
    if ((current_user && current_user.admin?) || session[:maskerading]) && !params[:mask].blank?
      original_user =  session[:maskerading] || current_user.id
      user = nil
      if params[:mask] == 'reset'
        user = User.find session[:maskerading]
        session[:marketing] = nil
      else
        user = User.find_by_email(params[:mask])
      end
      if user.nil?
        redirect_to(root_path, alert: 'This user does not exist')
        return
      end
      sign_out
      sign_in :user, user
      session[:maskerading] = original_user
    end
  end
  # Devise permitted params
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(
      :email,
      :password,
      :password_confirmation)
    }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(
      :email,
      :password,
      :password_confirmation,
      :current_password
      )
    }
  end

  # Redirects on successful sign in
  def after_sign_in_path_for(resource)
    if resource.studio.nil?
      flash[:notice] = "You are not assigned to any studio yet" unless resource.sign_in_count == 1
      root_path
    else
      year_studio_student_posts_path(@year, resource.studio, resource)
    end
  end

  # Only permits admin users
  def require_admin!
    authenticate_user!

    if current_user && !current_user.admin?
      redirect_to root_path, alert: "You must be admin to access this page"
    end
  end
  helper_method :require_admin!

  def require_director!
    authenticate_user!
    if current_user && !current_user.locked? && !current_user.role == :student
      redirect_to root_path, alert: "You must be a studio director to access this page"
    end
  end

  def require_same_year!
    authenticate_user!
    redirect_to(users_path(current_year: current_user.year), alert: "You cannot manage other years") if (current_user.year_id != @year.id && !current_user.admin?)
    redirect_to(users_path(current_year: current_user.year), alert: "You cannot manage other years") if current_user.year_id != @year.id && !current_user.admin?
  end

  def check_locked!
    redirect_to(users_path(current_year: current_user.year), alert: 'You cannot make changes to this site anymore') if current_user && current_user.locked?
  end

  def load_years
    @years = Year.all.order(%{archived ASC, created_at DESC})
  end

  def load_current_year
    @year = @years.find{|y| y.slug == params[:year_id] || y.slug == params[:id]} || Year.first
    load_current_studios
  end

  def load_current_studios
    @studios = Studio.year(@year).includes(:students, :tags)
  end

  def load_categories
    @all_categories = @year.tags_on :categories
  end

  before_filter :disable_xss_protection

  protected
  def disable_xss_protection
    # Disabling this is probably not a good idea,
    # but the header causes Chrome to choke when being
    # redirected back after a submit and the page contains an iframe.
    # http://stackoverflow.com/questions/19106111/rails-4-redirects-to-data-in-chrome/21341180#21341180
    response.headers['X-XSS-Protection'] = "0"
  end


  # Auto-sign out locked users
  def reject_locked!
    if current_user && current_user.locked?
      sign_out current_user
      user_session = nil
      current_user = nil
      flash[:alert] = "Your account is locked."
      flash[:notice] = nil
      redirect_to root_url
    end
  end
  helper_method :reject_locked!
end
