class Post < ActiveRecord::Base
	has_many :participations
	has_many :authors, through: :participations, class_name: "User"
	
	validates_presence_of :body
end