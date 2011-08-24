Feature: Describe about seller page

  Background:
    Given I am signed up as a seller with "seller@person.com/password"
    And I sign in as "seller@person.com/password"

  Scenario: Show about seller page
    Then I go to the dashboard sellers page
    And I should be on the about dashboard sellers page
    And I should not see "Authorization Failure"

  Scenario: User with role user don't have access to about page
    Given I am logged out
    Given I am signed up as "email@person.com/password"
    Then I sign in as "email@person.com/password"
    Then I go to the dashboard sellers page
    And I should see "Authorization Failure"

  Scenario: Create a valid abouts
    Then I go to the about dashboard sellers page
    And I fill in "static_data_about" with "This is I am"
    And I fill in "static_data_faq" with "This is my faq"
    And I fill in "static_data_term" with "This is my terms"
    And I press "static_data_submit"
    And I should be on the dashboard account fuck page
    And I should see "Your abouts are saved"
    Then I go to the about dashboard sellers page
    And I should see my about

  Scenario: Edit Return/Refund Policy
    Then I go to the return policy dashboard sellers page
    Then I fill in "static_data_return_policy" with "My Rerun/Refund Policy"
    And I press "static_data_submit"
    Then I should be on the dashboard account fuck page
    Then I go to the return policy dashboard sellers page
    And I should se my rerun policy
