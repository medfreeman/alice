class StudiosController < ApplicationController
	before_filter :authenticate_user!
	before_filter :check_admin

	def new
		@studio = Studio.new
	end

	def create
		@studio = Studio.new(studio_params)
		if @studio.save
			respond_to do |format|
				format.html {redirect_to new_studio_path(@studio), notice: "Studio was successfully created."}
				format.json {render json: @studio}
			end
		else
			render json: {errors: @studio.errors}, status: :unprocessable_entity
		end
	end

	def update
		@studio = Studio.find(params[:id])
		if @studio.update!(studio_params)
			render json: @studio
		else
			render json: @studio.errors
		end
	end

	def show
		@studio = Studio.includes(:director).find(params[:id])
		@director = @studio.director
		@students = @studio.students
	end

	def destroy
		@studio = Studio.find(params[:id])
		if @studio.deletable? && @studio.delete
			respond_to do |format|
				format.json {head :no_content}
			end
		else
			respond_to do |format|
				format.json {head :unprocessable_entity}
			end
		end
	end
	private

	def studio_params
		params.require(:studio).permit(:name)
	end

	def check_admin
		redirect_to root_path if !current_user.admin?
	end
end
