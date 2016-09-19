class UsersController < ApplicationController
	before_filter :require_director!
  before_filter :set_user, only: [:destroy, :update]

  def index
  	@users = User.year(@year).includes(:studio)
    @users_data = @users.map(&:serialize)
    @roles = User.roles.keys
  end

  def update
    if @user.update(permitted_params)
      render json: {user:@user.serialize}
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def create
  	@user = User.new(permitted_params)
  	if @user.save
  		render json: @user.serialize
  	else
  		render json: @user.errors, status: :unprocessable_entity
  	end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      #format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  def upload_form
  end

  def upload_post
  	require 'csv'
  	file = params.require(:users_csv).open
		year = @year
		user_count = 0

  	CSV.foreach(file, headers: true) do |row|
  		studio = Studio.find_or_create_by!(name: row['studio'], year: year) unless row['studio'].blank?
			u = User.find_by(email: row['email'])
			u = User.new if u.nil?
			role = row['role'].nil? ? :student : row['role']
			u.sciper = row['SCIPER']
			u.name = row['name']
			u.email = row['email']
			u.password = 'topsecret'
			u.password_confirmation = 'topsecret'
			u.role = role
      u.year = year
			u.studio = studio unless studio.nil?
			user_count += 1
			u.save! if (!u.persisted? || u.changed?)
  	end
  	redirect_to year_users_path(@year), notice: "#{user_count} successfully created/updated."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def permitted_params
    params_ = params.require(:user).permit(:name, :email, :sciper, :studio, :role, :super_student, :year_id).to_h
    if params_.keys.include?('studio')
      params_["studio"] = params_["studio"].blank? ? nil : Studio.find(params_["studio"])
    end
    if !params_["super_student"].blank?
      params_["super_student"] = params_["super_student"] == 'true' ? true : false
    end
    params_
  end
end
