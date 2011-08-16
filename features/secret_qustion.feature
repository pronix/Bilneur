Feature: Describe how work secret question

  Background:
   Given I am signed up as "email@person.com/password"
   And default "secret_question_variants" fixture are load
   Given I sign in as "email@person.com/password"

  Scenario: Check public questions
    Given I am on the new secret question page
    And I should see in "secret_question_secret_question_variant_id" all public questions

  Scenario Outline: Check with empty field with regular question
    Given I am on the new secret question dashboard page
    And I select "<variant>" from "secret_question_secret_question_variant_id"
    And I fill in "Answer" with "<answer>"
    And press "Save"
    And I should be on the <page_name>
    And I should see "<should_see>"

    Examples:
      | variant                     | answer      | page_name                           | should_see              |
      | What is your favorite town? | Kaliningrad | dashboard account fuck page         |                         |
      |                             | Kaliningrad | edit secret question dashboard page | Please check a question |
      | What is your favorite town? |             | edit secret question dashboard page | Please write you answer |

  Scenario Outline: Check with empty field with own question    
    Given I am on the new secret question dashboard page
    Then I select "Write your question" from "secret_question_secret_question_variant_id"
    And I fill in "Own Question" with "<question>"
    And I fill in "Answer" with "<answer>"
    And I press "Save"
    Then I should be on the <page_name>
    And I should see "<should_see>"

    Examples:
      | question          | answer         | page_name                           | should_see              |
      | Its good quastion | this is answer | dashboard account fuck page         |                         |
      |                   | this is answer | edit secret question dashboard page | Please check a question |
      | Its good quastion |                | edit secret question dashboard page | Please write you answer |

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
    And I should see "Secret Question save"
    And I must be sure that "email@person.com" has question "My secret question"
    And I must be sure that "email@person.com" has answer "Answer for secret question"

  Scenario: Check own question and answer on page
    Given I have a own question "My Own Question" with answer "My answer"
    Then I go to the edit secret question page
    And "secret_question_secret_question_variant_id" should be selected for "My Own Question"

  Scenario: Update own question
    Given I have a own question "My Own Question" with answer "My answer"
    Then I go to the edit secret question page
    And I fill in "Own Question" with "My secret question new"
    And I fill in "Answer" with "Answer for secret question"
    And I press "Save"
    Then I should be on the dashboard account fuck page
    And I should see "Secret Question updated"

  Scenario: Return password by security question, regular question
    Given I have regular question "What is your favorite sports team?" with answer "I dont know"
    And I am logged out
    Then I go to the sign in page
    Then I follow "Forgot Password?"
    And I should see "Reset password via secret question"
    And I fill in "email" with my email
    And I select "What is your favorite sports team?" from "secret_question_secret_question_variant_id"
    And I fill in "Answer" with "I dont know"
    Then I press "Reset password"
    Then I should be on the reset password by question page
    And I fill in "New Password" with "moloko"
    And I fill in "Confirm New Password" with "moloko"
    Then I press "Reset Password"
    And I should be on the sign in page
    And I should see "Password is reset, please log in"
    Then I try to auth with "email@person.com" and "moloko"
    And I should be on the products page

  Scenario: Recovery password by security question, own question
    Given I have a own question "My Own Question" with answer "My answer"
    And I am logged out
    Then I go to the sign in page
    Then I follow "Forgot Password?"
    And I fill in "email" with my email
    And I fill in "Own Question" with "My Own Question"
    And I fill in "Answer" with "My answer"
    Then I press "Reset password"
    Then I should be on the reset password by question page
    And I fill in "New Password" with "moloko"
    And I fill in "Confirm New Password" with "moloko"
    Then I press "Reset Password"
    And I should be on the sign in page
    And I should see "Password is reset, please log in"
    Then I try to auth with "email@person.com" and "moloko"
    And I should be on the products page

  Scenario: Recovery password by wrong email and regular question
    Given I have regular question "What is your favorite sports team?" with answer "I dont know"
    And I am logged out
    Then I go to the sign in page
    Then I follow "Forgot Password?"
    And I should see "Reset password via secret question"
    And I fill in "email" with "bademail@example.com"
    And I select "What is your favorite sports team?" from "secret_question_secret_question_variant_id"
    And I fill in "Answer" with "I dont know"
    Then I press "Reset password"
    And I should be on the forgot password page
    And I should see "Sorry but wrong email address"

  Scenario Outline: Check reset password by question page
    Given I have <question_type> "What is your favorite sports team?" with answer "Test answer"
    And I am logged out
    Then I go to the forgot password page
    And I fill in "email" with "<email>"
    And I <fill_select> <with_from> "<answer_field>"
    And I fill in "Answer" with "Test answer"
    Then I press "Reset password"
    And I should be on the <page_name>

    # Use one question for reqular and own question but question has diff type
    # 1. Test with rigth data with regular question
    # 2. Test with rigth data with own question
    # 3. Test with wrong email with regular question
    # 4. Test with wrong email with own question
    # 5. Test with wrong question with regular question
    # 6. Test with wrong question with own question

    Examples:
    | question_type    | email            | fill_select                                 | with_from | answer_field                               | page_name              |
    | regular question | email@person.com | select "What is your favorite sports team?" | from      | secret_question_secret_question_variant_id | reset by question page |
    | a own question   | email@person.com | fill in "Own Question"                      | with      | What is your favorite sports team?         | reset by question page |
    | regular question | bad@person.com   | select "What is your favorite sports team?" | from      | secret_question_secret_question_variant_id | forgot password page   |
    | a own question   | bad@person.com   | fill in "Own Question"                      | with      | What is your favorite sports team?         | forgot password page   |
    | regular question | email@person.com | select "What is your favorite town?"        | from      | secret_question_secret_question_variant_id | forgot password page   |
    | a own question   | email@person.com | fill in "Own Question"                      | with      | BAD QUESTION                               | forgot password page   |
    | regular question | email@person.com | select "What is your favorite sports team?" | from      | secret_question_secret_question_variant_id | reset by question page |



# @wip    
#   Scenario: Create secret question with invalid params
#     Given I am on the new secret question page
#     Then I select "What is your favorite town?" from "secret_question_secret_question_variant_id"
#     And I fill in "Answer" with ""
#     Then I should see "Field can not be blank"
#     Then I should be on the new secret question page
    
