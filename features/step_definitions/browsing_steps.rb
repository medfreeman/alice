Given(/^there is a post$/) do
  @post = Fabricate(:post)
end

When(/^I visit the post$/) do
  visit post_path(@post)
end

Then(/^I should see the post$/) do
  expect(page).to have_content('The post\'s body')
end


Given(/^there is an studio named (\w+)$/) do |studio|
  @studio = Fabricate(:studio)
end

Given(/^there is a post that belongs to (\w+)$/) do |studio|
  Fabricate(:post, studio: @studio)
end

When(/^I visit the studio (\w+)$/) do |studio|
  visit studio_path(@studio)
end
