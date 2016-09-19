class Year < ActiveRecord::Base
	has_many :users
	has_many :students, -> {where(role: User.roles[:student])}, class_name: "User"
	has_many :directors, -> {where(role: User.roles[:director])}, class_name: "User"
	has_many :posts
	has_many :studios
	has_many :featured_posts, ->{where(featured: true)}, class_name: 'Post'
	validates :slug, presence: true, uniqueness: true, format: { without: /[! #?]/}


	has_attached_file :logo,
		:styles => {
			:header => "300x100>"
		},
		:default_url => "logo-alice.png"
	validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/

	def to_param
		slug
	end

	def archive!
		if !archived
			users.where.not(admin: true).each do |u|
				u.lock!
				u.email += '.locked'
				u.confirm!
				u.save!
			end
			self.archived = true
			self.save!
		end
	end
end
