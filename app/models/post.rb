class Post < ActiveRecord::Base
	belongs_to :studio
	has_many :participations
	has_many :authors, through: :participations, class_name: "User"	
	has_many :assets, as: :assetable
  
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
	validates_presence_of :title, :body

	def status
		self[:status] ? "formes" : "processus"
	end

end