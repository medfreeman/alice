class Post < ActiveRecord::Base
	has_many :participations
	has_many :authors, through: :participations, class_name: "User"	
	belongs_to :studio

	scope :featured, ->{where(featured: true)}
	accepts_nested_attributes_for(:participations)	
	validates_presence_of :body, :studio
end