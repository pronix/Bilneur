# language: en

Feature: Shopping

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as "email@person.com/password"
    And 1 payment methods exist
    And 1 bogus payment methods exist
    And the following sellers exist:
      | firstname | email              | password  | password_confirmation |
      | Seller1   | seller1@person.com | password1 | password1             |
      | Seller2   | seller2@person.com | password2 | password2             |
      | Seller3   | seller3@person.com | password3 | password3             |
    And the following products exist:
      | name                        |            ean | created_at | owner                    |
      | The Godfather               |  9780099528128 | 01/01/2011 | email:seller1@person.com |
      | Death of a Hero [Paperback] | 978-0919614789 | 01/01/2010 | email:seller1@person.com |
    And the following variants exist:
      | product                          | seller                   | price | condition | count_on_hand | owner                    |
      | name:The Godfather               | email:seller1@person.com |  12.0 | new       |             6 | email:seller1@person.com |
      | name:The Godfather               | email:seller2@person.com |  14.0 | new       |             5 | email:seller2@person.com |
      | name:The Godfather               | email:seller3@person.com |  10.0 | used      |            10 | email:seller3@person.com |
      | name:Death of a Hero [Paperback] | email:seller1@person.com | 22.89 | new       |             7 | email:seller1@person.com |
      | name:Death of a Hero [Paperback] | email:seller2@person.com | 24.50 | new       |             4 | email:seller2@person.com |
      | name:Death of a Hero [Paperback] | email:seller3@person.com |  20.0 | used      |            10 | email:seller3@person.com |
    And  the following shipping methods exist:
      | seller                   | name        |
      | email:seller2@person.com | UPS Ground1 |
      | email:seller1@person.com | UPS Ground2 |
      | email:seller3@person.com | UPS Ground3 |

  @javascript
  Scenario: Adding quote to cart and checkout(only one seller)
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    Then I should be on the cart page
    When I go to the "Death of a Hero [Paperback]" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    Then I should be on the cart page
    When I follow "Checkout" within block normal cart
    And I fill shipping address with correct data
    And I press "Save and Continue"
    When I choose "UPS Ground1" from seller "seller2@person.com" Shipping Methods
    And I press "Save and Continue"
    And I fill billing address with correct data
    And I choose "Credit Card"
    And I enter valid credit card details
    Then I should see "Your order has been processed successfully"
    And "seller2@person.com" should receive 1 emails
    And "email@person.com" should receive 1 emails
    When buyer "email@person.com" paid orders
    And seller "seller2@person.com" set shipment status as "ship"
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
    Then I should be on the cart page
    When I go to the "Death of a Hero [Paperback]" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller1@person.com"
    And I press "Add To Cart" within block seller "seller1@person.com"
    Then I should be on the cart page
    When I follow "Checkout" within block normal cart
    And I fill shipping address with correct data
    And I press "Save and Continue"
    When I choose "UPS Ground1" from seller "seller2@person.com" Shipping Methods
    And I choose "UPS Ground2" from seller "seller1@person.com" Shipping Methods
    And I press "Save and Continue"
    And I fill billing address with correct data
    And I choose "Credit Card"
    And I enter valid credit card details
    Then I should see "Your order has been processed successfully"
    And "seller2@person.com" should receive 1 emails
    And "seller1@person.com" should receive 1 emails
    And "email@person.com" should receive 1 emails
    When buyer "email@person.com" paid orders
    And seller "seller2@person.com" set shipment status as "ship"
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

