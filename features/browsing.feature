Feature: Browsing the site

Scenario: Visitors can see a post
	Given there is a post
	When I visit the post
	Then I should see the post

@wip
Scenario: A user adds a post
	Given I am logged in
	And I belong to atelier Pellacani
	When I add a post
	Then atelier Pellacani should have a post
	And I should be an author of the post

@wip
Scenario: Posts are sorted by ateliers
	Given there is an atelier named Pellacani
	Given there is a post that belongs to Pellacani
	When I visit the atelier Pellacani
	Then I should see the post