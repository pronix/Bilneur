Feature: Search on the dashboard/quoute

  Background:
    Given I am signed up as a seller with "seller@person.com/password"
    When I sign in as "seller@person.com/password"
    Given the following products exist:
      | name                        | available_on        |            ean | sku     | created_at |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 | TE-6000 | 01/01/2011 |
      | Test product 3              | 2011-01-06 20:21:13 |  828282-221221 | TE-8000 | 01/01/2010 |
      | Test product 4              | 2011-01-06 20:21:13 | 382818202-2222 | TE-9000 | 01/01/2010 |
    And I have quotes for each product
    And quote "The Godfather" have warehouse is "bilneur"
    And quote "Test product 3" have warehouse is "seller"
    And I go to the dashboard quotes page

@javascript
  Scenario: Search
    And "select_by" should be selected "all_active"
    And "search_string" should has value ""
    Then I fill in "search_string" with "9780099528128"
    And I on the "search_string" and press enter
    And I should see only "The Godfather" from all products
    Then I fill in "search_string" with "Test product 3"
    And I on the "search_string" and press enter
    And I should see only "Test product 3" from all products
    Then I fill in "search_string" with ""
    And I select "Bilneur" from "select_by"
    And I should see only "The Godfather" from all products
    And "select_by" should be selected "bilneur"
    And I select "Other" from "select_by"
    And I should see only "Test product 3" from all products
    And "select_by" should be selected "seller"


  Scenario: Show only active products
    Given the following products exist:
      | name             | available_on        |          ean | sku     | created_at |
      | non active produ | 2011-01-06 18:21:13 | 978009952811 | TE-6666 | 01/01/2011 |
    Then I should not see "non active produ"

  Scenario: Show other seller quotes
    Then I click by href "/dashboard/quotes/other" link
    Then I should be on the dashboard quotes other page
    Then I should see only "Test product 3" by all product

  Scenario: Edit the quote
    Then silent exec "@quote = Product.find_by_name('The Godfather').variants.last"
    Then I click "Edit" by dom_id "@quote"
    And I should be on the edit dashboard quotes @quote

  Scenario: Delete the quote
    Then I click "Delete" by dom_id variant for "The Godfather" product
    Then I should see "Quote deleted"
    And I should not see "The Godfather"
    And I should have qutes by marked as "deleted"
