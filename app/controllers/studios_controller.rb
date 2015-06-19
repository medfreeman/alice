class StudiosController < ApplicationController
	before_filter :authenticate_user!
	before_filter :check_admin

	def new
		@studio = Studio.new
	end

	def create
		@studio = Studio.new(studio_params)
		if @studio.save
			redirect_to studio_path(@studio), notice: "Studio was successfully created."
		else
			render :new
		end
	end

	def show
		@studio = Studio.includes(:director).find(params[:id])
		@director = @studio.director
		@students = @studio.students
	end

	private

	def studio_params
		params.require(:studio).permit(:name)
	end

	def check_admin
		redirect_to root_path if !current_user.admin?
	end
end
