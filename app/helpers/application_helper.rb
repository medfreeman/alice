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
  	@year.display_by_users? ? _student_path(student) : year_student_posts_path(@year, options[:studio], student)
  end

  def _year_studio_most_recent_path(year, studio)
  	year_studio_most_recent_path(@year, studio, current_year: @year)
  end

  def _post_path post
    !post.category_list.empty? ?
      category_post_path(post.tags_on(:categories).first.slug, post, current_year: @year) :
				@year.display_by_users? ? student_post_path(post.first_author, post, current_year: @year) :
				year_studio_post_path(@year, post.studio, post)
  end

  def _tag_path post
    @year.display_as_users? ?
      studio_tag_path(post.studio, tag, current_year: @year) :
      year_tag_path(tag, current_year: @year)
  end
end
