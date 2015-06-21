Feature:
	As an assistant
	I can manage the users

	Scenario: I create a studio
		Given I am logged in as an admin
		When I create a studio named pellacani
		Then there is a studio named pellacani

	Scenario: I upload a csv file
		Given I am logged in as an admin
		When I upload a csv of users
		Then there should be all users from the csv