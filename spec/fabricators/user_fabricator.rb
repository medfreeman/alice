Fabricator(:user) do
	email {sequence(:email) {|i| "tester_#{i}@epfl.ch"}}
	password "topsecret"
	password_confirmation "topsecret"
end