Feature: Describe buyer feedback to seller

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
    And the following variants exist:
      | product            | seller                   | price | condition | count_on_hand | owner                    |
      | name:The Godfather | email:seller1@person.com |  12.0 | used      |             6 | email:seller1@person.com |
      | name:The Godfather | email:seller2@person.com |  14.0 | new       |             5 | email:seller2@person.com |
      | name:The Godfather | email:seller3@person.com |  10.0 | new       |            10 | email:seller3@person.com |

  Scenario: Don't show Seller Review in buyer when it's blank
    Given I sign in as "email@person.com/password"
    Given I have order
    Then I go to the account page
    And I follow "Feedback"
    Then I should not see "Feedback as a Seller"

@wip @javascript
  Scenario: Show feedback to buyer with some sellers
    Given I sign in as "email@person.com/password"
    Given I have order with all variants by product "The Godfather"
    Given I have for each seller in order some review
    Then I go to the account page
    Then sleep "300"
    And I follow "Feedback"
    # Then I go to the orders dashboard page
    # And I should see my order
    # And I should see "Seller Review"
    # And I should see each review by seller on order

  @wip
  Scenario: Show feedback to buyer with one seller
    Given I sign in as "email@person.com/password"
    Given I have order
    Given I review seller "seller1@person.com" with my order, review "simple review", rating "3"
    Then I go to the dashboard account fuck page
    And I follow "Orders"
    And I should see my order
    And I should see "Seller Review"
    And I should see my rating for "seller1@person.com"
    And I should see "seller1@person.com" fullname

  Scenario: Dont show Buyer review if seller dont have review
    Given I sign in as "seller1@person.com/password1"
    Then I go to the dashboard seles page
    And I should not see "Buyer Review"

  Scenario: Show feedback for sellers
    Given I sign in as "seller1@person.com/password1"
    Given my products bought "3" users with create some review
    Then I go to the dashboard seles page
    And I should see "Buyer Review"
    And I should see "3" orders with reviews

  # Background:
  #   Given I have an admin account of "admin@person.com/password"
  #   And I am signed up as "email@person.com/password"
  #   And 1 payment methods exist
  #   And 1 bogus payment methods exist
  #   And the following sellers exist:
  #     | firstname | email              | password  | password_confirmation |
  #     | Seller1   | seller1@person.com | password1 | password1             |
  #   And the following products exist:
  #     | name                        |            ean | created_at | owner                    |
  #     | The Godfather               |  9780099528128 | 01/01/2011 | email:seller1@person.com |
  #   And the following variants exist:
  #     | product                          | seller                   | price | condition | count_on_hand | owner                    |
  #     | name:The Godfather               | email:seller1@person.com |  12.0 | new       |             6 | email:seller1@person.com |
  #   And  the following shipping methods exist:
  #     | seller                   | name        |
  #     | email:seller1@person.com | UPS Ground2 |


 # @javascript
 #  Scenario: Create a feedback to order
 #    When I sign in as "email@person.com/password"
 #    And I go to the "The Godfather" product page
 #    And I follow "View All"
 #    And I set quatility "3" within block seller "seller1@person.com"
 #    And I press "Add To Cart" within block seller "seller1@person.com"
 #    Then I should be on the cart page
 #    When I follow "Checkout" within block normal cart
 #    And I fill shipping address with correct data
 #    And I press "Save and Continue"
 #    When I choose "UPS Ground2" from seller "seller1@person.com" Shipping Methods
 #    And I press "Save and Continue"
 #    And I choose "Other address"
 #    And I fill billing address with correct data
 #    And I choose "Credit Card"
 #    And I enter valid credit card details
 #    Then I should see "Your order has been processed successfully"
 #    When buyer "email@person.com" paid orders
 #    And seller "seller1@person.com" set shipment status as "ship"
 #    Then change order to paid
 #    Then change order to shipped
 #    Then create seller review and receiving

# FUCK FUCK FUCK!
#   Scenario: Create a feedback to order
#     Given I sign in as "email@person.com/password"
#     Given I user has order with "The Godfather" product
#     Given I add "UPS Ground2" shipment for order

