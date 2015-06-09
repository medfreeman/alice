Given(/^I am logged in$/) do
	@current_user = Fabricate(:user)
  visit new_user_session_path
  fill_in "Email", with: @current_user.email
  fill_in "Password", with: @current_user.password
end

Given(/^I belong to atelier (\w+)$/) do |atelier|
	@atelier ||= Atelier.find_by_name(atelier) || Fabricate(:atelier)
  @current_user.atelier = Atelier.find_by_name(atelier)
  @current_user.save!
end

When(/^I add a post$/) do
  visit new_post_path
  fill_in :post_body, with: "Some content"
  click_on "Save"
end

Then(/^there should be a post$/) do
  @post = Post.first
  expect(@post).not_to be_nil
end

Then(/^atelier (\w+) should have a post$/) do |atelier|
	@atelier ||= Atelier.find_by_name(atelier)
  expect(@atelier.posts).to include(@post)
end

Then(/^I should be an author of the post$/) do
  expect(@post.authors).to include(@current_user)
end