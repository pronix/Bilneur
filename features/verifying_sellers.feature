# language: en
Feature: Verifying sellers

  Scenario: Verifying sellers account
    Given I go to the home page
    When I follow "Start Selling"
    And I fill in "Firstname" with "first"
    And I fill in "Lastname" with "last"
    And I fill in "EmailSignup" with "email@person.com"
    And I fill in "PasswordSignup" with "password"
    And I fill in "PasswordConfirmation" with "password"
    And I press "Create"
    Then I should see "Welcome! You have signed up successfully.Should enter Payment Method"
    And I should be on the new dashboard payment_method page
    When I select "Credit Card" from "Type"
    And I fill in "Name" with "My credit card"
    And I press "Create"
    When I fill in "Card Type" with "visa"
    And I fill in "Code" with "1234 1234 1234 1234"
    And I fill in "CVV" with "234"
    And I fill in "Billing Address" with "xyz street, san jose, ca"
    And I fill in "Expiration" with "12/13"
    And I press "Update"
    When I go to the dashboard account page
    Then I should be on the dashboard account page

