Feature:
	As an assistant
	I can manage the users

	@javascript @wip
	Scenario: I create a studio
		Given I am logged in as an admin
		When I create a studio named pellacani with the tag maquette
		Then there is a studio named pellacani
		And the studio should have the tag maquette

	Scenario: I upload a csv file
		Given I am logged in as an admin
		When I upload a csv of users
		Then there should be all users from the csv

	@wip
	Scenario: I assign students
		Given I am logged in as an admin
		And I create a studio named pellacani
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
