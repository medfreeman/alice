module ApplicationHelper
	def admin_signed_in?
		user_signed_in? && current_user.admin?
	end

  def title(value)
    unless value.nil?
      @title = "#{value} | Alice"      
    end
  end

  def _student_path(student)
  	student_path(student, current_year: @year)
  end

  def _student_posts_path(student, options = {})
  	@year.display_by_users? ? _student_path(student) : student_posts_path(options[:studio], student, current_year: @year)
  end

  def _studio_most_recent_path(studio)
  	studio_most_recent_path(studio, current_year: @year)
  end

  def _post_path post
    @year.display_by_users? ? 
      student_post_path(post.first_author, post, current_year: @year) :
      post.studio.nil? ? 
        category_post_path(post.tags_on(:categories).first.slug, post, current_year: @year) :
        studio_post_path(post.studio, post, current_year: @year)
  end

  def _tag_path post
    @year.display_as_users? ?
      studio_tag_path(post.studio, tag, current_year: @year) : 
      year_tag_path(tag, current_year: @year)
  end
end
