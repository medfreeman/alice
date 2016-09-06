Given(/^there is a post$/) do
  @studio ||= Fabricate(:studio)
  @studio_students ||= [Fabricate(:user, studio: @studio)]
  @post = Fabricate(:post, authors: @studio_students, studio: @studio)
  @studio.posts << @post
end

When(/^I visit the post$/) do
  visit year_studio_path(@year, studio_id: @studio, id: @post)
end

Then(/^I should see the post$/) do
  expect(page).to have_content(@post.body)
  expect(page).to have_content(@post.authors.first.name)
end


Given(/^there is an studio named (\w+)$/) do |studio|
  @studio = Fabricate(:studio)
end

Given(/^the studio has (\d+) student$/) do |student_count|
  student_count.to_i.times do 
  	@studio.students << Fabricate(:user)
  end
  @studio_students = @studio.students
end

Given(/^there is a post that belongs to (\w+)$/) do |studio|
  @post = Fabricate(:post, authors: @studio_students, studio: @studio)
end

When(/^I visit the posts from (\w+)$/) do |studio|
  studio = Studio.find_by_name(studio.downcase)
  visit studio_path(@studio)
end
