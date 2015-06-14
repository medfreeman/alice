Given(/^I am logged in as (?:a|an) (\w+)$/) do |role|
	Fabricate(:user, role: role.to_sym)
end

When(/^I create a studio named (\w+)$/) do |studio|
  visit new_studio_path()
  fill_in :studio_name, with: studio
  within '.user-form' do 
  	fill_in :user_name, with: studio
  	fill_in :user_email, with: "#{studio}@epfl.ch"
  end
  click_on 'Save'
end

Then(/^the studio (\w+) has a director$/) do |studio|
	@studio ||= Studio.find(studio)
	expect(@studio.director).not_to be_nil
end