class Post < ActiveRecord::Base
	belongs_to :studio
	belongs_to :owner, class_name: 'User'
	has_many :participations
	has_many :authors, through: :participations, class_name: "User"
	has_many :assets, as: :assetable
  belongs_to :year
  scope :year, -> (year) { where(year: year).order('created_at DESC') }
  validates_presence_of :year

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

	default_scope {order('created_at DESC')}

	acts_as_taggable
	acts_as_taggable_on :categories

	has_attached_file :thumbnail,
		:styles => {
			:medium => "500>",
			:thumb => "220x220#"
		},
		:default_url => "/images/missing.jpg"
	before_post_process :transliterate_name
	validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/

	scope :featured, ->{where(featured: true)}
	accepts_nested_attributes_for(:participations)
	validates_presence_of :title, :body#, :thumbnail

	def status
		self[:status] ? "formes" : "processus"
	end

	def first_author
		authors.first
	end

	def to_parm
		slug
	end

	validate :file_dimensions

  def file_dimensions
  	return if thumbnail.queued_for_write[:original].nil?
	  dimensions = Paperclip::Geometry.from_file(thumbnail.queued_for_write[:original].path)
	  #self.width = dimensions.width
	  #self.height = dimensions.height
	  if dimensions.width > 3000 || dimensions.height > 3000
	    errors.add(:file,'Width or height cannot be wider or higher than 3000px')
	  end
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
  def transliterate_name
  	self.thumbnail_file_name = self.thumbnail_file_name.downcase.gsub(/[àäèüéö!ç]/i,
  		'ä' => 'a',
  		'à' => 'a',
  		'â' => 'a',
  		'è' => 'e',
  		'é' => 'e',
  		'ê' => 'e',
  		'ö' => 'o',
  		'ô' => 'o',
  		'î' => 'i',
  		'ï' => 'i',
  		'ü' => 'u',
  		'û' => 'u',
  		'ù' => 'u',
  		'ç' => 'c',
  		'!' => ''
  		)
  end

	def slug_candidates
		[ :title,
			[:title, :owner_name],
			[:title, :owner_name, :year_slug],
		]
	end

	def year_slug
		self.year.try(:slug)
	end

	def owner_name
		self.owner.try(:name)
	end
end
