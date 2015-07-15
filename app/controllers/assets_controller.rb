class AssetsController < ApplicationController
	def upload
		begin

			asset = Asset.create!(file: params[:file])
			render json: {
				link: asset.file.url(:large),
				mobile: asset.file.url(:large),
				xlarge: asset.file.url(:xlarge),
				original: asset.file.url,
			}
		rescue => e
			puts "Error #{e}"
			render json: {
				error: e.inspect
			}
		end
	end
end
 