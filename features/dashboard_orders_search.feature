Feature: Describe search on the dashboard/orders

  Background:
    Given I am signed up as a seller with "seller@person.com/password"
    Given the following products exist:
      | name                        | available_on        |            ean | sku     | created_at |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 | TE-6000 | 01/01/2011 |
    And I have quotes for each product
    Given I have 5 orders for "The Godfather"
    When I sign in as "seller@person.com/password"
    Then I go to the dashboard orders page

  Scenario: Show orders
    Then I should see 5 orders on the page

  Scenario: Print invoice
    Then silent exec "@order = Order.last"
    Then I click "Print Invoice" by dom_id "@order"
    Then I should get a download with content-type "application/pdf; charset=utf-8"
    
  Scenario Outline: Test Sort fields
    Then I click "<link>" link
    Then <click_second>
    And request query should contain "<search>"
    
    Examples:
      | link                  | click_second                         | search                            |
      | Order Date            | exec "nil"                           | search[meta_sort]=created_at.asc  |
      | Order Date            | I click "Order Date" link            | search[meta_sort]=created_at.desc |
      | Order Number/Quantity | exec "nil"                           | search[meta_sort]=number.asc      |
      | Order Number/Quantity | I click "Order Number/Quantity" link | search[meta_sort]=number.desc     |

@javascript
  Scenario: Search by number
    Then silent exec "@order = Order.last"
    And I fill in "search_number_contains" with @order.number
    And I on the "search_number_contains" and press enter
    And I should see only @order on the page
