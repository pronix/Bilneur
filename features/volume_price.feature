@wip
Feature: Describe volume price

  Background:
    Given I am signed up as a seller with "seller@person.com/password"
    When I sign in as "seller@person.com/password"
    Given the following products exist:
      | name                        | available_on        |            ean | sku     | created_at |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 | TE-6000 | 01/01/2011 |
    And I have quotes for each product
@javascript
  Scenario: Create a volume price for quote
    Then I go to the dashboard quotes page
    And I follow "Edit"
    Then I follow "Selling" in the class "prflBus"
    And I should be on the dashboard selling options page for @quote
    Then I click "Add Volume Price" link
    And I follow new volume price with given values:
      | display    | range | amount | 
      | 5 and more | (5+)  |      5 | 
    And I should see "new volume price created"
    And I should see given on the page:
      | display    | range | amount |
      | 5 and more | (5+)  |      5 |

  Scenario: Edit volume price
    Given I have volume price for @quote
    Then I go to the dashboard selling options page for @quote
    And I change "range" with "2...3"
    And I click "save" link
    And I should see "vole price updated"
    
  Scenario: Delete volume price
    Given I have volume price for @quote
    Then I go to the dashboard selling options page for @quote
    Then I click "Remove"
    And I should see "Volume price is removed"
    And I should not have volume price for @quote

  Scenario: Buy quote by volume price
    Given seller1 have quote "product 1" with price "1500"
    Given quote "product 1" from seller1 with volume price range "(5+)" and price "1400"
    Given I am registered user
    And I go to the seller "seller1" store page
    And I click "product 1" link
    And I should be on the "seller1" product "product 1" page
    And I should see price for "product 1" "1500"
    And I should see "Buy More and save money" with price "1400" and quanity "5"
    Then I click "add to cart" on the "Buy More and save money"
    And I should be on the cart page
    And I should see "product 1" with qty "5" and price "1400"
    Then I click "Checkout"
    When I buy a 5 "product 1" qty of "product 1" should be 5
