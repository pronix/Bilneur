# language: en

Feature: Group Purchases
  The buyer can participate in group purchasing

  Scenario: Purachse
    Given exists the following group sales:
     | seller           | product | count | price | retail_price | start sales | end sales  | purchases |
     | seller1@test.com | pr1     |    10 | 97.22 |          100 | 01/01/2011  | 01/02/2011 |        10 |
     | seller1@test.com | pr2     |    10 |    98 |          100 | 01/01/2011  | 01/02/2011 |         9 |
     | seller1@test.com | pr3     |    10 | 99.09 |          100 | 01/01/2011  | 01/02/2011 |         0 |
    When I go to the "pr1" product page
    And I follow "View All" with "Group Discount"
    And I set quatility "3" within block seller "seller1@test.com"
    And press "Buy"
    And I fill shipping address with correct data
    And I press "Calculate shipping"
    And I choose "UPS"
    And I press "Checkout"
    And I enter valid credit card details
    And I press "Place Order"
    Then I should see "Your order has been processed successfully"


  Scenario: Complete purchase
    Given exists the following group sales:
     | seller           | product | count | price | retail_price | start sales | end sales  | purchases |
     | seller1@test.com | pr1     |    10 | 97.22 |          100 | 01/01/2011  | 01/02/2011 |        10 |
     | seller1@test.com | pr2     |    10 |    98 |          100 | 01/01/2011  | 01/02/2011 |         9 |
     | seller1@test.com | pr3     |    10 | 99.09 |          100 | 01/01/2011  | 01/02/2011 |         0 |
    And I bought 1 items of goods "pr1"
    When seller "seller1@test.com" completed group sales for the product "pr1"
    Then I should receive a emails of completion of the purchase
    And I have the product "pr1" with "Group purchases"

  Scenario: Cancel purchase
    Given exists the following group sales:
     | seller           | product | count | price | retail_price | start sales | end sales  | purchases |
     | seller1@test.com | pr1     |    10 | 97.22 |          100 | 01/01/2011  | 01/02/2011 |        10 |
     | seller1@test.com | pr2     |    10 |    98 |          100 | 01/01/2011  | 01/02/2011 |         9 |
     | seller1@test.com | pr3     |    10 | 99.09 |          100 | 01/01/2011  | 01/02/2011 |         0 |
    And I bought 1 items of goods "pr1"
    When seller "seller1@test.com" cancled group sales for the product "pr1"
    Then I should receive a emails of cancellation of the purchase
    And I have balance "97.22"
