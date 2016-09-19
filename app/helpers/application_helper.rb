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
  	year_student_path(@year, student)
  end

  def _student_posts_path(student, options = {})
  	@year.display_by_users? ? year_student_path(@year, student) : year_student_posts_path(@year, options[:studio], student)
  end

  def _year_studio_most_recent_path(year, studio)
  	year_studio_most_recent_path(@year, studio )
  end

  def _post_path post
    !post.category_list.empty? ?
      year_category_post_path(@year, post.tags_on(:categories).first.slug, post ) :
				@year.display_by_users? ? year_student_post_path(@year, post.first_author, post ) :
				year_studio_post_path(@year, post.studio, post)
  end

  def _tag_path post
    @year.display_as_users? ?
      studio_tag_path(post.studio, tag ) :
      year_tag_path(tag )
  end
end
