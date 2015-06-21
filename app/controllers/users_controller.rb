class UsersController < ApplicationController
	before_filter :require_admin!
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
end
