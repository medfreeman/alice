Feature:
	As a user
	I can add a post

	Scenario: I add a post
		Given I am logged in
		And I belong to studio Pellacani
		When I add a post
		Then there should be a post
		And I should be an author of the post