class AssetsController < ApplicationController
	def upload
		begin
			asset = Asset.create!(file: params[:file])
			render json: {
				link: asset.file.url(:large)
			}
		rescue => e
			render json: {
				error: e.inspect
			}
		end
	end
end
 