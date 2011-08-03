# language: en

Feature: Sign up
  In order to be able to make a sales
  A visitor
  Should be able to sign up as seller

  Scenario: Seller signs up with valid data
    When I go to the sign up page
    And I fill in "Email" with "email@person.com"
    And I fill in "Password" with "password"
    And I fill in "Password Confirmation" with "password"
    And I check "as seller"
    And I press "Create"
    Then I should see "You have signed up successfully."
    And "email@person.com" should have role "seller"

  Scenario: Seller tries to sign up with invalid data
    When I go to the sign up page
    And I fill in "Email" with "bademail"
    And I press "Create"
    Then I should see "Email is invalid" within "#errorExplanation"
    And I should see "Password can't be blank" within "#errorExplanation"
