class Studio < ActiveRecord::Base
	before_validation :set_slug
	validates :name, presence: true
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

	def to_param
		slug
	end

	def as_json options = nil
		{
			id: id,
			name: name,
			tag_list: tag_list.join(', '),
		}
	end

	def deletable?
		self.posts.empty? && self.students.empty?
	end

	def students_emails
		students.map(&:email).join(', ')
	end

	#old taggings must be erased for the tags to be sorted by taggings.id
	def update! attrs = {}
		new_tags = attrs['tag_list'].split(',').map(&:squish)
		if attrs['tag_list'] != new_tags
			self.taggings.delete_all
		end
		super attrs
	end

	private
	def set_slug
		if self.slug.nil?
			self.slug = self.name.try(:parameterize)
			self.errors[:slug] << "has already been taken for year #{self.year.name}" unless self.year.studios.where(slug: self.slug).empty?
		end
	end
end
