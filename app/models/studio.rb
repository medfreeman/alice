class Studio < ActiveRecord::Base
	extend FriendlyId
	has_many :students, ->{where(role:  User.roles[:student])}, class_name: 'User', foreign_key: :studio_id
	has_one :director, ->{where(role:  User.roles[:director])}, class_name: 'User', foreign_key: :studio_id
	has_many :posts, through: :students

	friendly_id :name, use: [:slugged, :finders]

end