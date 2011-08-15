Feature: Describe how work secret question

  Background:
   Given I am signed up as "email@person.com/password"
   And default "secret_question_variants" fixture are load
   Given I sign in as "email@person.com/password"

@wip
  Scenario: Create a secret question with public variant
    And I follow "My Account"
    Then I should be on the "email@person.com" account page
    Then I should see "My Account"
    Then I follow "Secret Question"
    Then I select "What is your favorite town?" from "secret_question_secret_question_variant_id"
    And I fill in "Answer" with "Kaliningrad"
    And press "Save"
    And I should be on the dashboard account fuck page
    And I should see "Secret Question save"
    And I must be sure that "email@person.com" has question "What is your favorite town?"
    And I must be sure that "email@person.com" has answer "Kaliningrad"
 
