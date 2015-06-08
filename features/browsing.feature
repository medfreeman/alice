Feature: Browsing the site

@wip
Scenario: Visitors can see a post
	Given there is a post
	When I visit the post
	Then I should see the post