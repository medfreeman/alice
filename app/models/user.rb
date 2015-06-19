class User < ActiveRecord::Base
  belongs_to :studio
  has_many   :participations, foreign_key: :author_id
  has_many   :posts, through: :participations
  
  scope :unassigned, ->{ where(studio_id: nil)}

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [:student, :director]

  paginates_per 100
  
  # Validations
  # :email
  validates_format_of :email, with: /\A([^@\s]+)@epfl.ch/i
  
  def self.paged(page_number)
    order(admin: :desc, email: :asc).page page_number
  end
  
  def self.search_and_order(search, page_number)
    if search
      where("email LIKE ?", "%#{search.downcase}%").order(
      admin: :desc, email: :asc
      ).page page_number
    else
      order(admin: :desc, email: :asc).page page_number
    end
  end
  
  def self.last_signups(count)
    order(created_at: :desc).limit(count).select("id","email","created_at")
  end
  
  def self.last_signins(count)
    order(last_sign_in_at: 
    :desc).limit(count).select("id","email","last_sign_in_at")
  end
  
  def self.users_count
    where("admin = ? AND locked = ?",false,false).count
  end

  ################ Permissions #################
  
  def can_feature_post? post
    post.studio.director == self || self.admin?
  end

  def can_edit_post? post
    post.nil? || post.authors.include?(self)
  end

  ##############################################
end
