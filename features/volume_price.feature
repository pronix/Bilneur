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
    Then I click "Add Volume Price" link
    And I follow new volume price with given values:
      | start_range | end_range | amount |
      |           2 |         4 |      8 |
    And I press "save_shipping_method"
    And I should see given tables:
      | field                                          | value |
      | variant_volume_prices_attributes_0_start_range |     2 |
      | variant_volume_prices_attributes_0_end_range   |     4 |
      | variant_volume_prices_attributes_0_amount      |  8.00 |
    And I should have volume price with given values:
      | range  | start_range | end_range | amount | display |
      | (2..4) |           2 |         4 |   8.0  | 2 to 4  |

  Scenario: Edit volume price
    Then silent exec "@quote = Product.last.variants.last"
    Given I have volume price for @quote with given value:
      | start_range | end_range |
      |           2 |         8 |
    Then I go to the dashboard selling options page for @quote
    And I should see given tables:
      | field                                          | value |
      | variant_volume_prices_attributes_0_start_range |     2 |
      | variant_volume_prices_attributes_0_end_range   |     8 |
    Then I change some given values:
      | start_range | end_range |
      |           4 |           |
    And I press "save_shipping_method"
    And I should have volume price with given values:
      | range | start_range | end_range | display    |
      | (4+)  |           4 |           | 4 and more |
@javascript
  Scenario: Delete volume price
    Then silent exec "@quote = Product.last.variants.last"
    Given I have volume price for @quote with given value:
      | start_range | end_range |
      |           2 |         8 |
    Then I go to the dashboard selling options page for @quote
    Then I click "Remove" link
    Then I press "save_shipping_method"
    Then @quote should not have "volume_prices"
@javascript
  Scenario: Buy quote by option value
    Then silent exec "@quote = Product.last.variants.last"
    Given I have volume price for @quote with given value:
      | start_range | end_range |
      |           2 |         8 |
    Then I go to the sellers store quote by @quote
    Then I should see "Quantity 2 to 8"
    Then I press by sub div id "CollapsiblePanel2", "to_add"
    And I should see "2"
