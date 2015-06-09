Given(/^there is a post$/) do
  @post = Fabricate(:post)
end

When(/^I visit the post$/) do
  visit post_path(@post)
end

Then(/^I should see the post$/) do
  expect(page).to have_content('The post\'s body')
end


Given(/^there is an atelier named (\w+)$/) do |atelier|
  @atelier = Fabricate(:atelier)
end

Given(/^there is a post that belongs to (\w+)$/) do |atelier|
  Fabricate(:post, atelier: @atelier)
end

When(/^I visit the atelier (\w+)$/) do |atelier|
  visit atelier_path(@atelier)
end
