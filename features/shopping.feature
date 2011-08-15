# language: en
@wip
Feature: Shopping

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as "email@person.com/password"
    And the following sellers exist:
      | name    | email              | password  |
      | Seller1 | seller1@person.com | password1 |
      | Seller2 | seller2@person.com | password2 |
      | Seller3 | seller3@person.com | password3 |
    And the following products exist:
      | name                        | available_on        |            ean | sku     | created_at |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 | TE-6000 | 01/01/2011 |
      | Death of a Hero [Paperback] | 2011-01-06 20:21:13 | 978-0919614789 | TE-7000 | 01/01/2010 |
    And the following quotes exist:
      | product_name                | seller             | price | condition | count_on_hand |
      | The Godfather               | seller1@person.com |  12.0 | new       |             2 |
      | The Godfather               | seller2@person.com |  14.0 | new       |             1 |
      | The Godfather               | seller3@person.com |  10.0 | used      |            10 |
      | Death of a Hero [Paperback] | seller1@person.com | 22.89 | new       |             7 |
      | Death of a Hero [Paperback] | seller2@person.com | 24.50 | new       |             3 |
      | Death of a Hero [Paperback] | seller3@person.com |  20.0 | used      |            10 |
    And seller "seller3@person.com" has the following virtual shipping methods exist:
      | name             | cost |
      | Free to Bilnuer  | 0.00 |
      | Store the seller | 0.00 |

  Scenario: Adding quote to cart and checkout
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
    And I fill my address
    And I press "Save and Continue"
    When I choose "Ship to UPS" from seller "seller2@person.com" Shipping Methods
    And I press "Save and Continue"
    And I fill my billing address
    And I choose "Credit Card"

    And I enter valid credit card details
    Then I should see "Your order has been processed successfully"

