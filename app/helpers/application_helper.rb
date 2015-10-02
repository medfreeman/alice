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
  	student_path(student, year: @year)
  end

  def _student_posts_path(student, options = {})
  	@year.display_by_users? ? _student_path(student) : studio_student_posts_path(options[:studio], student, year: @year)
  end

  def _studio_most_recent_path(studio)
  	studio_most_recent_path(studio, year: @year)
  end

end
