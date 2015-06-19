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
	@studio ||= Studio.find_by_name(studio.downcase) || Fabricate(:studio, name: studio)
  @current_user.studio = @studio
  @current_user.save!
end

When(/^I add a post$/) do
  visit new_post_path
  fill_in :post_body, with: "Some content"
  click_on "Save"
  @post = Post.last
end

Then(/^there should be a post$/) do
  @post = Post.first
  expect(@post).not_to be_nil
end

Then(/^studio (\w+) should have a post$/) do |studio_name|
	studio = Studio.find(studio_name.downcase)
  expect(studio.posts).to include(@post)
end

Then(/^I should be an author of the post$/) do
  expect(@post.authors).to include(@current_user)
end

Given(/^I have a studio with (\d+) student(?:s)$/) do |students|
  @studio = Fabricate(:studio)
  students.to_i.times do 
    @studio.students << Fabricate(:user)
  end
  @students = @studio.students
  @user.studio = @studio
  @user.save!
end

Given(/^there are posts in my studio$/) do
  @students.first.posts << Fabricate(:post)
end

Then(/^there should be no post on the front page$/) do
  visit root_path
  expect(all('.post')).to be_empty
end

When(/^I feature a post$/) do
  @post ||= Post.first
  expect(@post).not_to be_featured
  visit studio_post_path(@studio, @post)
  expect(page).to have_content('Feature')
  click_on 'Feature'
  expect(@post.reload).to be_featured
end

Then(/^it should be in the front page$/) do
  visit root_path
  expect(page).to have_content(@post.body)
end