class Post < ActiveRecord::Base
	has_many :participations
	has_many :users, through: :participations
	
	validates_presence_of :body
end
