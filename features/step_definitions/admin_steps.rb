Given(/^I am logged in as (?:a|an) (\w+)$/) do |role|
  role = role.to_sym
  if role == :admin
    @user = Fabricate(:user, admin: true)
  else
    @user = Fabricate(:user, role: role.to_sym)
  end
  visit new_user_session_path()
  within '#new_user' do 
    fill_in :user_email, with: @user.email
    fill_in :user_password, with: @user.password
    click_on 'Sign in'
  end
end

When(/^I create a studio named (\w+)$/) do |studio|
  visit new_studio_path()
  fill_in :studio_name, with: studio
  click_on 'Save'
end

Then(/^there is a studio named (\w+)$/) do |studio|
  expect(Studio.find(studio)).not_to be_nil
  
end

Then(/^the studio (\w+) has a director$/) do |studio|
  @studio ||= Studio.find(studio)
  expect(@studio.director).not_to be_nil
end

Given(/^there is a director$/) do
  @director = Fabricate(:user, role: :director)
end

When(/^I upload a csv of users$/) do
  visit users_upload_path
  @csv_path = "#{Rails.root}/db/users.csv"
  attach_file('users_csv', @csv_path)
  click_on 'Submit'
end

Then(/^there should be all users from the csv$/) do
  expect(page.current_path).to eq(root_path)
  require('csv')
  CSV.foreach(@csv_path, headers: true) do |row|
    role = row['role'].nil? ? 'student' : row['role']
    user = User.find_by_email(row['email'])
    expect(user.studio.name).to eq(row['studio']) unless user.studio.nil?
    expect(user.role).to eq(role)
  end
end