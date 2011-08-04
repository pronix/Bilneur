Feature: Register user behavior on home page

  Background:
    Given I already sing as "email@person.com/password"

  Scenario: What I should see in home page
    When I go to the home page
    Then I should see given link with path
      | link       | link_path    | options        |
      | My Account | account page |                |
      | Logout     | logout       |                |
      |            | account page | as_seller=true |

  Scenario: Follow to Start Selling 
    When I go to the home page
    Then I follow Start Selling link as have role "user"
    And I should be on the account page
    And I should see "You are a sallers now"
    And user "email@person.com" should have a "seller" role
