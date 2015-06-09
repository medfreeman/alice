class Participation < ActiveRecord::Base
	belongs_to :author, class_name: "User"
	belongs_to :post
end