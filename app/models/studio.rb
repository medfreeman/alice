class Studio < ActiveRecord::Base
	extend FriendlyId
	friendly_id :slug_candidates, use: [:slugged, :finders]
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

	def slug_candidates
	    [
	      :name,
	      [:name, :year_slug],
	    ]
	end
	private
	def year_slug
		year.slug
	end
end
