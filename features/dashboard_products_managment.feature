@wip
Feature: Adding products
  In order to sale products
  As a seller
  I can add and manage products

  Background:
    Given I am signed up as "bobis@person.com/password"
    And the following option types exist:
      | name  | presentation | 
      | color | Color        |
    And the following taxons exist:
      | name      |
      | Furniture |
    And I am on the dashboard products page


  Scenario: Add product 
    When I press "New Product"
    And I fill in "Name" with "Table"
    And I fill in "EAN" with "F0J"
    And I fill in "Description" with "Awesome table"
    And I press "Next"
    And I press "Next"
    And I press "Next"
    And I press "Next"
    And I press "Next"
    Then I should see "Table"
    And I should see "Awesome table"
    And I should see "Proceed to products"

  Scenario: Add taxons in product wizard
    When I press "New Product"
    And I fill in "Name" with "Table"
    And I fill in "EAN" with "F0J"
    And I press "Next"
    And I choose "Furniture"
    And I press "Next"
    Then product should have "Furniture" taxon
    And product should be in options state
