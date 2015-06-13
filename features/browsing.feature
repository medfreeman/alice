Feature: Browsing the site

Scenario: Visitors can see a post
	Given there is a post
	When I visit the post
	Then I should see the post

@wip
Scenario: A user adds a post
	Given I am logged in
	And I belong to studio Pellacani
	When I add a post
	Then studio Pellacani should have a post
	And I should be an author of the post

@wip
Scenario: Posts are sorted by studios
	Given there is an studio named Pellacani
	Given there is a post that belongs to Pellacani
	When I visit the studio Pellacani
	Then I should see the post