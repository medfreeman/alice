Feature:
	As an assistant
	I can manage the users

	@wip
	Scenario: I create a studio
		Given I am logged in as an admin
		When I create a studio named pellacani
		Then the studio pellacani has a director