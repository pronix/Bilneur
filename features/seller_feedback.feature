Feature: Describe buyer feedback to seller

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as "email@person.com/password"
    And 1 payment methods exist
    And 1 bogus payment methods exist
    And the following sellers exist:
      | firstname | email              | password  | password_confirmation |
      | Seller1   | seller1@person.com | password1 | password1             |
    And the following products exist:
      | name                        |            ean | created_at | owner                    |
      | The Godfather               |  9780099528128 | 01/01/2011 | email:seller1@person.com |
    And the following variants exist:
      | product                          | seller                   | price | condition | count_on_hand | owner                    |
      | name:The Godfather               | email:seller1@person.com |  12.0 | new       |             6 | email:seller1@person.com |
    And  the following shipping methods exist:
      | seller                   | name        |
      | email:seller1@person.com | UPS Ground2 |
@wip @javascript
  Scenario: Create a feedback to order
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller1@person.com"
    And I press "Add To Cart" within block seller "seller1@person.com"
    Then I should be on the cart page
    When I follow "Checkout" within block normal cart
    And I fill shipping address with correct data
    And I press "Save and Continue"
    When I choose "UPS Ground2" from seller "seller1@person.com" Shipping Methods
    And I press "Save and Continue"
    And I choose "Other address"
    And I fill billing address with correct data
    And I choose "Credit Card"
    And I enter valid credit card details
    Then I should see "Your order has been processed successfully"
    When buyer "email@person.com" paid orders
    And seller "seller1@person.com" set shipment status as "ship"
    Then change order to paid
    Then change order to shipped
    Then create seller review and receiving

# FUCK FUCK FUCK!
#   Scenario: Create a feedback to order
#     Given I sign in as "email@person.com/password"
#     Given I user has order with "The Godfather" product
#     Given I add "UPS Ground2" shipment for order

