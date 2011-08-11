Feature: Describe how see all tops

  Background:
    Given I non register user
    Given I have "12" products with variant and "5" reviews
    Given I recalculate rating for each product

  Scenario: Check links in home page
    Given I non register user
    And I go to the home page
    And I should see given links in "menu"
      | link         | href              |
      | Top Products | top products page |
      | Top Sellers  | top sellers page  |
      | Top Deals    | top deals page    |

  Scenario: Describe top products page
    Then I go to the top products page
    And I should be on top products page
    And I should see top products with big ratting
