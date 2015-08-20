module PostsHelper

	def can_edit_categories?
		user_signed_in? && current_user.admin?
	end

	def can_feature_post? post
		user_signed_in? && current_user.can_feature_post?(post)
	end

	def can_edit_post? post
		user_signed_in? &&	current_user.can_edit_post?(post)
	end
end
