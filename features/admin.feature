@javascript
Feature:
	As an assistant
	I can manage the users

	Background:
		Given I am logged in as an admin

	Scenario: I create a studio
		When I create a studio named pellacani with the tag maquette
		Then there is a studio named pellacani
		And the studio should have the tag maquette

	Scenario: I upload a csv file
		When I upload a csv of users
		Then there should be all users from the csv

	@wip
	Scenario: I assign students
		When I create a studio named pellacani
		And the following users:
			| name     |
			| stud     |
			| stud1    |
			| director |
		When I assign the users as:
			| name  | role    | studio    |
			| stud  | student | pellacani |
			| stud1 | student | pellacani |
			| stud  | student | pellacani |
		Then the users should be the following:
			| name  | role    | studio    |
			| stud  | student | pellacani |
			| stud1 | student | pellacani |
			| stud  | student | pellacani |

	@wip
	Scenario: I archive a year
		Given the year has a user
		When I archive the year
		Then I can create a user with the same email
