Feature:
	As a user
	I can add a post

	Scenario: I add a post
		Given I am logged in
		And I belong to studio Pellacani
		When I add a post
		Then there should be a post
		And I should be an author of the post

	@wip
	Scenario: Director features a post
		Given I am logged in as a director
		And I have a studio with 2 students
		And there are posts in my studio
		Then there should be no post on the front page
		When I feature a post
		Then it should be in the front page