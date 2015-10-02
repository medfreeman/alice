class YearsController < ApplicationController
	before_filter :require_admin!
	before_filter :load_year_, except: [:create]

	def new

	end

	def create
		@year = Year.new(permitted_params)
		if @year.save
			respond_to do |format|
				format.html {redirect_to new_year_path(@year), notice: "Studio was successfully created."}
				format.json {render json: @year}
			end
		else
			render json: {errors: @year.errors}, status: :unprocessable_entity
		end
	end

	def update
		if @year.update!(permitted_params)
			respond_to do |format|
				format.html {redirect_to new_year_path(@year), notice: "Studio was successfully created."}
				format.json {render json: @year}
			end
		else
			render json: {errors: @year.errors}, status: :unprocessable_entity
		end
	end
	private

	def load_year_
		@year = params[:id].blank? ? Year.new : Year.find(params[:id])
	end

	def permitted_params
		params.require(:year).permit(:name, :slug, :logo, :link, :display_by_users)
	end
end
