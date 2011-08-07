# language: en
Feature: Sign up
  In order to be able to make a sales
  A visitor
  Should be able to sign up as seller
@wip
  Scenario: Sign up seller from main page with Start Selling link
    When I go to the home page
    Then I follow Start Selling link
    And I should be on the sign up page
    And the "as seller" checkbox should be checked

  Scenario: Seller signs up with valid data
    When I go to the sign up page
    And I fill in "Firstname" with "first"
    And I fill in "Lastname" with "last"
    And I fill in "EmailSignup" with "email@person.com"
    And I fill in "PasswordSignup" with "password"
    And I fill in "PasswordConfirmation" with "password"
    And I check "as seller"
    And I press "Create"
    Then I should see "You have signed up successfully."
    And "email@person.com" should have role "seller"

  Scenario: Seller tries to sign up with invalid data
    When I go to the sign up page
    And I fill in "EmailSignup" with "bademail"
    And I check "as seller"
    And I press "Create"
    Then I should see "Email is invalid" within "#errorExplanation"
    And I should see "Password can't be blank" within "#errorExplanation"
    And the "as seller" checkbox should be checked
