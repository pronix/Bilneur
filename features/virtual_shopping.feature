
@javascript
Feature: Virtual Shopping
  Virtiaul buyes can add product to V. Store
  and checkout virtual order

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as "email@person.com/password"
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

  Scenario: Adding quote to V.Cart and checkout order(with shipping method: Free to Bilneur and from one seller)
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To V.Store" within block seller "seller2@person.com"
    When I go to the "Death of a Hero [Paperback]" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To V.Store" within block seller "seller2@person.com"
    When I go to the cart page
    When I follow "Checkout" within block virtual cart
    When I choose "Ship to Bilneur" from seller "seller2@person.com" Shipping Methods
    And I press "Checkout"
    And I fill billing address with correct data
    And I enter valid credit card details
    And I press "Place Order"
    Then I should see "Your order has been processed successfully"
    And "seller2@person.com" should receive 1 emails
    And seller "seller2@person.com" should have new virtual order in sales with shipment state "pending"
    And buyer "email@person.com" should see orders in orders with shipment state "pending"
    When buyer "email@person.com" paid orders
    And seller "seller2@person.com" set shipment status as "ship"
    Then buyer "email@person.com" should see orders in orders with shipment state "shipped"
    And seller "seller2@person.com" should see the following quotes in dashboard:
      | product_name                | condition | count_on_hand |
      | The Godfather               | new       |             2 |
      | Death of a Hero [Paperback] | new       |             1 |
    And user "email@person.com" should see the following quotes in dashboard:
      | product_name                | price | condition | count_on_hand |
      | The Godfather               | 14.00 | new       |             3 |
      | Death of a Hero [Paperback] | 24.50 | new       |             3 |


  Scenario: Adding quote to V.Cart and checkout order(with shipping method: Free to Bilneur and from two seller)
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To V.Store" within block seller "seller2@person.com"
    When I go to the "Death of a Hero [Paperback]" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller1@person.com"
    And I press "Add To V.Store" within block seller "seller1@person.com"
    When I go to the cart page
    When I follow "Checkout" within block virtual cart
    And I choose "Ship to Bilneur" from seller "seller2@person.com" Shipping Methods
    And I choose "Ship to Bilneur" from seller "seller1@person.com" Shipping Methods
    And I press "Checkout"
    And I fill billing address with correct data
    And I enter valid credit card details
    And I press "Place Order"
    Then I should see "Your order has been processed successfully"
    And "seller2@person.com" should receive 1 emails
    And "seller1@person.com" should receive 1 emails
    And seller "seller2@person.com" should have new virtual order in sales with shipment state "pending"
    And seller "seller1@person.com" should have new virtual order in sales with shipment state "pending"
    And buyer "email@person.com" should see orders in orders with shipment state "pending"
    When buyer "email@person.com" paid orders
    And seller "seller1@person.com" set shipment status as "ship"
    And seller "seller2@person.com" set shipment status as "ship"
    Then buyer "email@person.com" should see orders in orders with shipment state "shipped"
    And seller "seller2@person.com" should see the following quotes in dashboard:
      | product_name                | condition | count_on_hand |
      | The Godfather               | new       |             2 |
      | Death of a Hero [Paperback] | new       |             4 |
    And seller "seller1@person.com" should see the following quotes in dashboard:
      | product_name                | condition | count_on_hand |
      | The Godfather               | new       |             6 |
      | Death of a Hero [Paperback] | new       |             4 |
    And user "email@person.com" should see the following quotes in dashboard:
      | product_name                | price | condition | count_on_hand |
      | The Godfather               | 14.00 | new       |             3 |
      | Death of a Hero [Paperback] | 22.89 | new       |             3 |

  Scenario: Adding quote to V.Cart and checkout order(with shipping method: Store the Seller)
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To V.Store" within block seller "seller2@person.com"
    When I go to the "Death of a Hero [Paperback]" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller1@person.com"
    And I press "Add To V.Store" within block seller "seller1@person.com"
    When I go to the cart page
    When I follow "Checkout" within block virtual cart
    And I choose "Store with seller" from seller "seller2@person.com" Shipping Methods
    And I choose "Store with seller" from seller "seller1@person.com" Shipping Methods
    And I press "Checkout"
    And I fill billing address with correct data
    And I enter valid credit card details
    And I press "Place Order"
    Then I should see "Your order has been processed successfully"
    And "seller2@person.com" should receive 1 emails
    And "seller1@person.com" should receive 1 emails
    And seller "seller2@person.com" should have new virtual order in sales with shipment state "pending"
    And seller "seller1@person.com" should have new virtual order in sales with shipment state "pending"
    And buyer "email@person.com" should see orders in orders with shipment state "pending"
    When buyer "email@person.com" paid orders
    Then buyer "email@person.com" should see orders in orders with shipment state "shipped"
    And seller "seller2@person.com" should see the following quotes in dashboard:
      | product_name                | condition | count_on_hand |
      | The Godfather               | new       |             2 |
      | Death of a Hero [Paperback] | new       |             4 |
    And seller "seller1@person.com" should see the following quotes in dashboard:
      | product_name                | condition | count_on_hand |
      | The Godfather               | new       |             6 |
      | Death of a Hero [Paperback] | new       |             4 |
    And user "email@person.com" should see the following quotes in dashboard:
      | product_name                | price | condition | count_on_hand |
      | The Godfather               | 14.00 | new       |             3 |
      | Death of a Hero [Paperback] | 22.89 | new       |             3 |
