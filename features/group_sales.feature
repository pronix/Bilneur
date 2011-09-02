# language: en

Feature: Group Sales
  Seller can creating group sale
  and completing and canceling

  Scenario: Creating
    Given I have the following products:
    | pr1 |
    | p23 |
    When I sign in
    And go to the inventory page
    And I follow "Create group sales" for the product "pr1"
    Then I should be on the new group sales page
    When I fill in "Start selling" with "01/01/2011"
    And I fill in "End sales" with "01/02/2011"
    And I fill in "Count products" with "10"
    And I fill in "Price" with "98.77"
    And I fill in "Retail price" with "100"
    And I fill in "Name" with "Buy ten kiwi at the price of eight"
    And I fill in "Description" with "Kiwi is best"
    And I fill in "Features" with "Sweet Kiwi"
    And I press "Create"

  Scenario: Editing

  Scenario: Deleting

  Scenario: Completing
    Given I have the following group sales:
     | product | count | price | retail_price | start sales | end sales  | purchases |
     | pr1     |    10 | 97.22 |          100 | 01/01/2011  | 01/02/2011 |        10 |
     | pr2     |    10 |    98 |          100 | 01/01/2011  | 01/02/2011 |         9 |


  Scenario: Canceling

