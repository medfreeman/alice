class UsersController < ApplicationController
	#before_filter :require_admin!, except: :index
  
  def index
  	@users = User.includes(:studio).all
    @users_data = @users.map(&:serialize)
    @roles = User.roles.keys
  end

  def update
    @user = User.find(params[:id])
    @user.update(permitted_params)
    render json: {user:@user.serialize}
  end

  def create
  	@user = User.new(permitted_params)
  	if @user.save
  		render json: @user.serialize
  	else
  		render json: @user.errors, status: :unprocessable_entity
  	end
  end

  def upload_form
  end

  def upload_post
  	require 'csv'
  	file = params[:users_csv].open
  	CSV.foreach(file, headers: true) do |row|
  		studio = Studio.find_or_create_by!(name: row['studio']) unless row['studio'].blank?
			user = User.find_or_create_by!(email: row['email']) do |u|
				role = row['role'].nil? ? :student : row['role']
				u.sciper = row['SCIPER']
				u.name = row['name']
				u.email = row['email']
				u.password = 'topsecret'
				u.password_confirmation = 'topsecret'
				u.role = role
				u.studio = studio unless studio.nil?
			end
  	end
  	redirect_to root_path
  end

  private
  def permitted_params
  	params.require(:user).permit(:name, :email, :sciper, :studio, :role)
  end
end