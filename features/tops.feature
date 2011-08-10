Feature: Describe how see all tops

  Background:
    Given I non register user

  Scenario: Check links in home page
    Given I non register user
    And I go to the home page
    And I should see given links in "menu"
      | link         | href              |
      | Top Products | top products page |
      | Top Sellers  | top sellers page  |
      | Top Deals    | top deals page    |
@wip  
  Scenario: Describe top products page
    Then I go to the top products page
    And I should be on top products page
    And I should see lates "10" products with big ratting
    
