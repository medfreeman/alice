Feature: Browsing the site
	As a visitor
	I can see the posts

	Scenario: Visitors can see a post
		Given there is a post
		When I visit the post
		Then I should see the post

	Scenario: Posts are sorted by studios
		Given there is an studio named Pellacani
		And the studio has 1 student
		And there is a post that belongs to Pellacani
		When I visit the posts from Pellacani
		Then I should see the post