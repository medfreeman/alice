class Atelier < ActiveRecord::Base
	has_many :users
	has_many :posts, through: :user
	
end
