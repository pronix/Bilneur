Feature: Describe dashboard purchases
  
  Background:
    Given I am signed up as a seller with "seller@person.com/password"
    Given the following products exist:
      | name                        | available_on        |            ean | sku     | created_at |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 | TE-6000 | 01/01/2011 |
    And I have quotes for each product
    When I sign in as "seller@person.com/password"
    Then I go to the dashboard purchases page
@javascript
  Scenario: Search by 
    Given I have order by following values and product "The Godfather":
      | number  | created_at |
      | R000111 | 13.days    |
      | R000222 | 50.days    |
    Then I go to the dashboard purchases page
    And "select_by" should be selected ""
    And I should see all my orders
    Then I fill in "search_number_contains" with "R000222"
    And I on the "search_number_contains" and press enter
    Then I should be on the dashboard purchases page
    And I should see only order with number "R000222"
    Then I fill in "search_number_contains" with ""
    Then I select "Last 30 days" from "select_by"
    And I should see only order with number "R000111"
    And "select_by" should be selected "created_at_greater_than_or_equal_to--30"
    Then I select "Last 60 days" from "select_by"
    And I should see all my orders
    And "select_by" should be selected "created_at_greater_than_or_equal_to--60"
