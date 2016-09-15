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

When(/^I create a studio named (\w+) with the tag (\w+)$/) do |studio, tags|
  visit year_users_path @year
  first('[data-tab="studios-list"]').click
  expect(page).to have_content('Add Studio')
  fill_in :name, with: studio
  fill_in :tag_list, with: tags
  click_on 'Add Studio'
end

Then(/^there is a studio named (\w+)$/) do |studio|
  wait_for_ajax
  @studio = Studio.find(studio)
  expect(@studio).not_to be_nil
end

Then(/^the studio (\w+) has a director$/) do |studio|
  @studio ||= Studio.find(studio)
  expect(@studio.director).not_to be_nil
end

Given(/^there is a director$/) do
  @director = Fabricate(:user, role: :director)
end

When(/^I upload a csv of users$/) do
  visit year_users_upload_path @year
  @csv_path = "#{Rails.root}/db/users.csv"
  attach_file('users_csv', @csv_path)
  click_on 'Submit'
end

Then(/^there should be all users from the csv$/) do

  require('csv')
  CSV.foreach(@csv_path, headers: true) do |row|
    role = row['role'].nil? ? 'student' : row['role']
    user = User.find_by_email(row['email'])
    expect(user.studio.name).to eq(row['studio']) unless user.studio.nil?
    expect(user.role).to eq(role)
  end
end

Given(/^the following users:$/) do |table|
  table.hashes.each do |row|
    name = row['name']
    Fabricate(:user, name: name, email: "#{name}@epfl.ch")
  end
end

When(/^I assign the users as:$/) do |table|
  visit assign_users_path
  table.hashes.each do |row|
    name = row[:name]
    within(".#{name}") do
      select(row['role'], from: '.roles')
    end
  end
end

Then(/^the users should be the following:$/) do |table|
  table.hashes.each do |row|
    user = User.find(row['name'])
    expect(user.studio.name).to eq(row['studio'])
    expect(user.role).to eq(row['role'].to_sym)
  end
end

Then(/^the studio should have the tag (\w+)$/) do |tag|
  expect(@studio.tag_list.join(', ')).to eq(tag)
end
