Given(/^I am logged in$/) do
	@current_user = Fabricate(:user)
  visit root_path
	click_on 'LOGIN'
  fill_in "Email", with: @current_user.email
  fill_in "Password", with: @current_user.password
  click_on "Log in"
  expect(page).not_to have_content(/Log in/i)
end

Given(/^I belong to studio (\w+)$/) do |studio|
	@studio ||= Studio.find_by_name(studio.downcase) || Fabricate(:studio, name: studio, year: @year)
  @current_user.studio = @studio
  @current_user.save!
end

Given(/^the studio has a student named (\w+)$/) do |student|
  @studio.students << Fabricate(:user, name: student)

end

When(/^I add a post$/) do
  visit new_year_post_path @year
  post = Post.new(body: "Some content", title: 'some title')
	fill_in :post_title, with: post.title
  fill_in :post_body, with: post.body
  click_on "Save"
  @post = Post.last
end

When(/^I add a post with (\w+)$/) do |coauthor|
	visit new_year_post_path @year
	post = Post.new(body: "Some content", title: 'some title')
	fill_in :post_title, with: post.title
	fill_in :post_body, with: post.body
	check coauthor
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

Then(/^(\w+) should be an author of the post$/) do |coauthor|
  expect(@post.authors.map(&:name)).to include(coauthor)
end

Given(/^I have a studio with (\d+) student(?:s)$/) do |students|
  @studio = Fabricate(:studio, year: @year)
  students.to_i.times do
    @studio.students << Fabricate(:user, year: @year)
  end
  @students = @studio.students
  @user.studio = @studio
  @user.save!
end

Given(/^there are posts in my studio$/) do
  Fabricate(:post, authors: @studio.students, studio: @studio, year: @year)
end

Then(/^there should be no post on the front page$/) do
  visit root_path
  expect(all('.post')).to be_empty
end

When(/^I feature a post$/) do
  @post ||= Post.first
  expect(@post).not_to be_featured
  visit year_studio_post_path(@year, @studio, @post)
  expect(page).to have_selector('.unfeatured')
  find('.unfeatured').click
	wait_for_ajax
  expect(@post.reload).to be_featured
end

Then(/^it should be on my studio page$/) do
  visit year_studio_path(@year, @studio)
  expect(page).to have_content(@post.body)
end

Given(/^the following students:$/) do |table|
  table.hashes.each do |row|
    studio = Studio.find_by_name(row['studio']) || Fabricate(:studio, name: row['studio'], year: @year)
    studio.students << Fabricate(:user, name: row['name'], year: @year)
  end
end

Given(/^the following posts:$/) do |table|
  table.hashes.each do |row|
    user = User.find_by_name(row['authors'])
    user.posts << Fabricate(:post, body: row['post_body'], studio: user.studio, year: @year)
  end
end

When(/^I visit student (\w+)$/) do |student|
  user = User.find_by_name(student)
  visit year_student_posts_path(@year, user.studio, user)
end

Then(/^I should see the following posts$/) do |table|
  table.hashes.each do |row|
    if row['visible'] == 'true'
      expect(page).to have_content(row['post_body'])
    else
      expect(page).not_to have_content(row['post_body'])
    end
  end

end
