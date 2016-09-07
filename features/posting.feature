Feature:
	As a user
	I can add a post

	Scenario: I add a post
		Given I am logged in
		And I belong to studio Pellacani
		And the studio has a student named walid
		When I add a post with walid
		Then there should be a post
		When I visit the post
		Then walid should be an author of the post

	@javascript
	Scenario: Director features a post
		Given I am logged in as a director
		And I have a studio with 2 students
		And there are posts in my studio
		Then there should be no post on the front page
		When I feature a post
		Then it should be on my studio page

	Scenario: User has posts
		Given the following students:
			| name    | studio    |
			| walid   | pellacani |
			| ahmed   | pellacani |
		And the following posts:
			| authors | post_body |
			| walid   | walid 1   |
			| walid   | walid 2   |
			| ahmed   | ahmed 3   |
		When I visit student walid
		Then I should see the following posts
			| visible | post_body |
			| true    | walid 1   |
			| true    | walid 2   |
			| false   | ahmed 3   |
