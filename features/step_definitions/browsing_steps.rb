Given(/^there is a post$/) do
  @post = Fabricate(:post)
end

When(/^I visit the post$/) do
  visit post_path(@post)
end

Then(/^I should see the post$/) do
  expect(page).to have_content('The post\'s body')
end