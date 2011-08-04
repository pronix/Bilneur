Feature: Seller behavior on home page

  Background:
    Given I already sing as "seller@person.com/password" with "seller" role

  Scenario: What I should see in home page
    When I go to the home page
    Then I should see given link with path
      | link          | link_path                 | options |
      | My Account    | account page              |         |
      | Logout        | logout                    |         |
      | Start Selling | the dashboard quotes page |         |

  Scenario: Check Dashboar quates
    And I am on the home page
    Then I click "Start Selling" link
    And I should be on the dashboard quotes page
