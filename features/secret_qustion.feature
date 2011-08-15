Feature: Describe how work secret question

  Background:
   Given I am signed up as "email@person.com/password"
   And default "secret_question_variants" fixture are load
   Given I sign in as "email@person.com/password"

  Scenario: Check public questions
    Given I am on the new secret question page
    And I should see in "secret_question_secret_question_variant_id" all public questions

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

  Scenario: Update a secret question with piblic variant
    Given I already have secret question "What is your favorite town?" with answer "Kaliningrad"
    Then I go to the edit secret question page
    And I should be on the edit secret question page
    And I should see my question on the "secret_question_secret_question_variant_id"
    And I should see my answer on the "Answer"
    Then I select "What is my mothers maiden name?" from "secret_question_secret_question_variant_id"
    Then I fill in "Answer" with "This is secret"
    And press "Save"
    Then I should be on the dashboard account fuck page
    And I should see "Secret Question updated"
    And I must be sure that "email@person.com" has question "What is my mothers maiden name?"
    And I must be sure that "email@person.com" has answer "This is secret"

  Scenario: Create secret question by create own question
    Given I am on the new secret question page
    # And "own_question_div" should be invisible
    Then I select "Write your question" from "secret_question_secret_question_variant_id"
    # And "own_question_div" should be visible
    And I fill in "Own Question" with "My secret question"
    And I fill in "Answer" with "Answer for secret question"
    And I press "Save"
    Then I should be on the dashboard account fuck page
    And I must be sure that "email@person.com" has question "My secret question"
    And I must be sure that "email@person.com" has answer "Answer for secret question"

  Scenario: Check own question and answer on page
    Given I have a own question "My Own Question" with answer "My answer"
    Then I go to the edit secret question page
    And "secret_question_secret_question_variant_id" should be selected for "My Own Question"
    

    
  
# @wip    
#   Scenario: Create secret question with invalid params
#     Given I am on the new secret question page
#     Then I select "What is your favorite town?" from "secret_question_secret_question_variant_id"
#     And I fill in "Answer" with ""
#     Then I should see "Field can not be blank"
#     Then I should be on the new secret question page
    
