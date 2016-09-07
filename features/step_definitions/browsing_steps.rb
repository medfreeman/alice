Given(/^there is a post$/) do
  @studio ||= Fabricate(:studio, year: @year)
  @studio_students ||= [Fabricate(:user, studio: @studio, year: @year)]
  @post = Fabricate(:post, authors: @studio_students, studio: @studio, year: @year)
  @studio.posts << @post
end

When(/^I visit the post$/) do
  visit _post_path(@post)
end

Then(/^I should see the post$/) do
  expect(page).to have_content(@post.body)
  expect(page).to have_content(@post.authors.first.name)
end


Given(/^there is an studio named (\w+)$/) do |studio|
  @studio = Fabricate(:studio, year: @year)
end

Given(/^the studio has (\d+) student$/) do |student_count|
  student_count.to_i.times do
  	@studio.students << Fabricate(:user, year: @year)
  end
  @studio_students = @studio.students
end

Given(/^there is a featured post that belongs to (\w+)$/) do |studio|
  @post = Fabricate(:post, authors: @studio_students, studio: @studio, year: @year, featured: true)
end

When(/^I visit the posts from (\w+)$/) do |studio|
  studio = Studio.find_by_name(studio.downcase)
  visit year_studio_path(@year, @studio)
end
