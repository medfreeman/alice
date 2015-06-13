Given(/^I am logged in$/) do
	@current_user = Fabricate(:user)
  visit new_user_session_path
  fill_in "Email", with: @current_user.email
  fill_in "Password", with: @current_user.password
  within ".new_user" do 
    click_on "Sign in"
  end
  expect(page).not_to have_content(/sign in/i)
end

Given(/^I belong to studio (\w+)$/) do |studio|
	@studio ||= Studio.find_by_name(studio) || Fabricate(:studio)
  @current_user.studio = Studio.find_by_name(studio)
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

Then(/^studio (\w+) should have a post$/) do |studio|
	@studio ||= Studio.find_by_name(studio)
  expect(@studio.posts).to include(@post)
end

Then(/^I should be an author of the post$/) do
  expect(@post.authors).to include(@current_user)
end