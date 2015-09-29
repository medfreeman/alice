class AssetsController < ApplicationController
	def upload
		asset = Asset.new(file: params[:file])
		if asset.save
			render json: {
				link: asset.file.url(:large),
				mobile: asset.file.url(:large),
				xlarge: asset.file.url(:xlarge),
				original: asset.file.url,
			}
		else
			render json: {
				error: asset.errors
			}
		end
	end
end
 