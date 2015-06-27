module ApplicationHelper
	def admin_signed_in?
		user_signed_in? && current_user.admin?
	end

  def title(value)
    unless value.nil?
      @title = "#{value} | Alice"      
    end
  end
end
