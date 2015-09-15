class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :reject_locked!, if: :devise_controller?
  before_filter :load_studios
  before_filter :load_categories

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
      studio_student_posts_path(resource.studio, resource)
    end
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
    if current_user && !current_user.role == :student
      redirect_to root_path, alert: "You must be a studio director to access this page"
    end
  end

  def load_studios
    @studios = Studio.all
  end

  def load_categories
    @all_categories = Post.tags_on :categories
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
end
