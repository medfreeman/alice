class Studio < ActiveRecord::Base
	extend FriendlyId
	friendly_id :name, use: [:slugged, :finders]
	validates :name, uniqueness: true, presence: true
	default_scope {order('name ASC')}

	belongs_to :year
	scope :year, -> (year) { where(year: year) }
	validates_presence_of :year

	has_many :users, class_name: 'User', foreign_key: :studio_id
	has_many :students, ->{where(role:  User.roles[:student])}, class_name: 'User', foreign_key: :studio_id
	has_one :director, ->{where(role:  User.roles[:director])}, class_name: 'User', foreign_key: :studio_id
	has_many :posts
	has_many :featured_posts, ->{where(featured: true).order('created_at')}, class_name: 'Post'
	acts_as_taggable

	def deletable?
		self.posts.empty? && self.students.empty?
	end
end
