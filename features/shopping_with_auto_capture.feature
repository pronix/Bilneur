Feature: Shopping (with auto capture)

  Background:
    Given a spree param "auto_capture" set is 'true'
    Given load test data

@javascript
  Scenario: Adding quote to cart and checkout(only one seller)
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    When I go to the "Death of a Hero [Paperback]" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    When I go to the cart page
    When I follow "Checkout" within block normal cart
    And I fill shipping address with correct data
    And I press "Save new address"
    And I press "Continue"
    Then sleep "3"
    When I press "Checkout"
    And I fill billing address with correct data
    And I enter valid credit card details
    And I press "Place Order"
    Then I should see "Your order has been processed successfully"
    And "seller2@person.com" should receive 1 emails
    And "email@person.com" should receive 1 emails
    When seller "seller2@person.com" set shipment status as "ship"
    Then buyer "email@person.com" should see orders in orders with shipment state "shipped"
    And seller "seller2@person.com" should see the following quotes in dashboard:
      | product_name                | condition | count_on_hand |
      | The Godfather               | new       |             2 |
      | Death of a Hero [Paperback] | new       |             1 |

@javascript
  Scenario: Adding quote to cart and checkout(with two seller)
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    When I go to the "Death of a Hero [Paperback]" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller1@person.com"
    And I press "Add To Cart" within block seller "seller1@person.com"
    When I go to the cart page
    When I follow "Checkout" within block normal cart
    And I fill shipping address with correct data
    And I press "Save new address"
    And I press "Continue"
    And I press "Checkout"
    And I fill billing address with correct data
    And I enter valid credit card details
    And I press "Place Order"
    Then I should see "Your order has been processed successfully"
    And "seller2@person.com" should receive 1 emails
    And "seller1@person.com" should receive 1 emails
    And "email@person.com" should receive 1 emails
    When seller "seller2@person.com" set shipment status as "ship"
    And seller "seller1@person.com" set shipment status as "ship"
    Then buyer "email@person.com" should see orders in orders with shipment state "shipped"
    And seller "seller2@person.com" should see the following quotes in dashboard:
      | product_name                | condition | count_on_hand |
      | The Godfather               | new       |             2 |
      | Death of a Hero [Paperback] | new       |             4 |
    And seller "seller1@person.com" should see the following quotes in dashboard:
      | product_name                | condition | count_on_hand |
      | The Godfather               | new       |             6 |
      | Death of a Hero [Paperback] | new       |             4 |

