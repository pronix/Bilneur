# language: en

Feature: Virtual Shopping
  Virtiaul buyes can add product to V. Store
  and checkout virtual order

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as "email@person.com/password"
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
      | product                          | seller                   | price | condition | count_on_hand |
      | name:The Godfather               | email:seller1@person.com |  12.0 | new       |             2 |
      | name:The Godfather               | email:seller2@person.com |  14.0 | new       |             5 |
      | name:The Godfather               | email:seller3@person.com |  10.0 | used      |            10 |
      | name:Death of a Hero [Paperback] | email:seller1@person.com | 22.89 | new       |             7 |
      | name:Death of a Hero [Paperback] | email:seller2@person.com | 24.50 | new       |             3 |
      | name:Death of a Hero [Paperback] | email:seller3@person.com |  20.0 | used      |            10 |
    # And seller "seller3@person.com" has the following virtual shipping methods exist:
    #   | name             | cost |
    #   | Free to Bilnuer  | 0.00 |
    #   | Store the seller | 0.00 |

  @focus @javascript
  Scenario: Adding quote to V.Cart and checkout order(with shipping method: Free to Bilneur)
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To V.Store" within block seller "seller2@person.com"
    Then I should be on the cart page
    Then show me the page

    # When I follow "Checkout" within block virtual cart
    # When I choose "Free to Bilneur" from shipping methods
    # And I press "Save and Continue"
    # And I choose "Credit Card" from "Payment Methods"
    # And I fill in "Credit card number" with "4111111111111111"
    # And I fill in "Security code" with "123"
    # And I fill in "Expiration" with "11/2014"
    # And I press "Save and Continue"
    # Then I should see order info
    # When I press "Place Order"
    # Then seller "seller3@person.com" should receive email
    # And seller "seller3@person.com" should see new order in sales tab in dashboard with shipping state "pending"
    # And user "email@person.com" should see new order in orders tab in dashboard with shipping state "pending"
    # When seller "seller3@person.com" set shipping status as "shipped"
    # Then user "email@person.com" should see order in orders tab in dashboard with shipping state "shipped"
    # And user "email@person.com" should see the following quotes in dashboard:
    #   | product_name  | price | condition | count_on_hand |
    #   | The Godfather |  10.0 | used      |             3 |
    # And seller "seller3@person.com" should see the following quotes in dashboard:
    #   | product_name  | price | condition | count_on_hand |
    #   | The Godfather |  10.0 | used      |             7 |

  @wip
  Scenario: Adding quote to V.Cart and checkout order(with shipping method: Store the Seller)
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I set quatility "3" for "The Godfather"
    And I follow "Add V.Store" for "seller3@person.com"
    Then I should be on the cart page
    When I follow "Checkout" for "virtual card"
    And I choose "Store the Seller" from shipping methods
    And I press "Save and Continue"
    And I choose "Credit Card" from "Payment Methods"
    And I fill in "Credit card number" with "4111111111111111"
    And I fill in "Security code" with "123"
    And I fill in "Expiration" with "11/2014"
    And I press "Save and Continue"
    Then I should see order info
    When I press "Place Order"
    Then user "email@person.com" should see the following quotes in dashboard:
      | product_name  | price | condition | count_on_hand        |
      | The Godfather |  10.0 | used      | 3 (store the seller) |
    And seller "seller3@person.com" should see the following quotes in dashboard:
      | product_name  | price | condition | count_on_hand |
      | The Godfather |  10.0 | used      |             7 |
    And seller "seller3@person.com" should see the following virtual quotes in dashboard:
      | product_name  | price | condition | count_on_hand                        |
      | The Godfather |  10.0 | used      | 3 (virtual buyer: email@person.com ) |

