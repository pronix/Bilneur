Feature: Describe how see all tops

  Background:
    Given I non register user

  Scenario: Check links in home page
    Given I have "12" products with variant and "5" reviews
    Given I recalculate rating for each product
    Given I non register user
    And I go to the home page
    And I should see given links in "menu"
      | link         | href              |
      | Top Products | top products page |
      | Top Sellers  | top sellers page  |
      | Top Deals    | top deals page    |

  Scenario: Describe top products page
    Given I have "12" products with variant and "5" reviews
    Then I go to the top products page
    And I should be on top products page
    And I should see top products with big ratting

  Scenario: Describe top sellers
    # TODO: I think it's not good DESC seller only for rating, we should user avg_raging with reviews_count
    Given I have "12" sellers user with different reviews
    Then I go to the top sellers page
    And I should be on the top sellers page
    And I should see "10" top sellers on the page

  Scenario: Describe top deals
    Given I have "12" products with variant and random price
    Then I go to the top deals page
    And I should be on the top deals page
    And I should see "10" top deals on th page
    Then show me the page
