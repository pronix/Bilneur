Feature: Describe about seller page

  Background:
    Given I am signed up as a seller with "seller@person.com/password"
    And I sign in as "seller@person.com/password"

  Scenario: Show about seller page
    Then I go to the dashboard abouts page
    And I should be on the dashboard abouts page
    And I should not see "Authorization Failure"

  Scenario: User with role user don't have access to about page
    Given I am logged out
    Given I am signed up as "email@person.com/password"
    Then I sign in as "email@person.com/password"
    And I go to the dashboard abouts page
    And I should see "Authorization Failure"
    And I should be on the dashboard abouts page
