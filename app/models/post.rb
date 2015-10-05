class Post < ActiveRecord::Base
	belongs_to :studio
	has_many :participations
	has_many :authors, through: :participations, class_name: "User"	
	has_many :assets, as: :assetable
  belongs_to :year
  scope :year, -> (year) { where(year: year).order('created_at DESC') }
  validates_presence_of :year

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders]

	default_scope {order('created_at DESC')}

	acts_as_taggable
	acts_as_taggable_on :categories

	has_attached_file :thumbnail,
		:styles => {
			:medium => "500>",
			:thumb => "220x220#"
		},
		:default_url => "/images/missing.jpg"
	validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/

	scope :featured, ->{where(featured: true)}
	accepts_nested_attributes_for(:participations)	
	validates_presence_of :title, :body, :thumbnail

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
end