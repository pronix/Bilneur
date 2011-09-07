@wip
Feature: Adding products with quotes
  In order to sale products
  As a seller
  I can add products and quotes with taxons, options, images and properties


  Background:
    Given I am signed up as "bobis@person.com/password"
    And I try to auth with "bobis@person.com" and "password" 
    And the following option types exist:
      | name  | presentation | 
      | color | Color        |
    And the following taxons exist:
      | name      |
      | Furniture |
    And the following products exist:
      | name                        |            ean | created_at | owner                    |
      | The Godfather               |  9780099528128 | 01/01/2011 | email:seller1@person.com |
      | Death of a Hero [Paperback] | 978-0919614789 | 01/01/2010 | email:seller1@person.com |
    And I am on the dashboard quotes page

  Scenario: Add quote to existing product
    When I fill in "ean" with "9780099528128"
    And I press "Add quote"
    And I should see "The Godfather"
    And I should see "New Quote"

  Scenario: Show wizard for quote without product
    When I press "Add quote"
    Then I should be on the product wizard page

  @javascript
  Scenario: Add product with quote
    When I press "Add quote"
    And I fill in "Name" with "Table"
    And I fill in "EAN or ISBN" with "123456"
    And I fill in "Description" with "Awesome table"
    And I press "Next"
    And I wait for the AJAX call to finish
    And I press "Next"
    And I wait for the AJAX call to finish
    And I fill in "quote_weight" with "34"
    And I fill in "quote_price" with "98"
    And I fill in "quote_count_on_hand" with "5"
    And I press "Next"
    And I wait for the AJAX call to finish
    Then product "Table" should have quote 
    And variant should exist with weight: 34, price: 98, count_on_hand: 5, name: "The Godfather"

  @javascript
  Scenario: Show validation errors for product
    When I press "Add quote"
    And I press "Next"
    Then I should see "There were problems with the following fields"
  
  @javascript
  Scenario: Show validation errors for product
    When I press "Add quote"
    And I fill in "Name" with "Table"
    And I fill in "EAN or ISBN" with "123456"
    And I fill in "Description" with "Awesome table"
    And I press "Next"
    And I wait for the AJAX call to finish
    And I press "Next"
    And I wait for the AJAX call to finish
    And I press "Next"
    Then I should see "There were problems with the following fields"
