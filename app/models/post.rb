class Post < ActiveRecord::Base
	has_many :participations
	has_many :authors, through: :participations, class_name: "User"	
	belongs_to :studio
	has_many :assets, as: :assetable

	has_attached_file :thumbnail,
		:styles => {
			:medium => "500>",
			:thumb => "150x90#"
		},
		:default_url => "/images/missing.jpg",
		:use_timestamp => false
	validates_attachment_content_type :thumbnail, :content_type => /\Aimage\/.*\Z/

	scope :featured, ->{where(featured: true)}
	accepts_nested_attributes_for(:participations)	
	validates_presence_of :body, :studio

	def status
		self[:status] ? "formes" : "processus"
	end

end