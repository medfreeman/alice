class Studio < ActiveRecord::Base
	extend FriendlyId
	belongs_to :director, class_name: 'User'
	has_many :students, class_name: 'User', foreign_key: :studio_id
	has_many :posts, through: :students

	friendly_id :name, use: [:slugged, :finders]


end
