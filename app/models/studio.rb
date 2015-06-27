class Studio < ActiveRecord::Base
	extend FriendlyId
	friendly_id :name, use: [:slugged, :finders]
	validates :name, uniqueness: true, presence: true

	has_many :students, ->{where(role:  User.roles[:student])}, class_name: 'User', foreign_key: :studio_id
	has_one :director, ->{where(role:  User.roles[:director])}, class_name: 'User', foreign_key: :studio_id
	has_many :posts

	def deletable?
		self.posts.empty? && self.students.empty? 
	end
end