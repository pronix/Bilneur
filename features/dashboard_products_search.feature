Feature: Search something on the dashboard

  Background:
    Given I am signed up as a seller with "seller@person.com/password"
    When I sign in as "seller@person.com/password"
    Given the following products exist:
      | name                        | available_on        |            ean | sku     | created_at |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 | TE-6000 | 01/01/2011 |
      | Death of a Hero [Paperback] | 2011-01-06 20:21:13 | 978-0919614789 | TE-7000 | 01/01/2010 |
      | Test product 3              | 2011-01-06 20:21:13 |  828282-221221 | TE-8000 | 01/01/2010 |
      | Test product 4              | 2011-01-06 20:21:13 | 382818202-2222 | TE-9000 | 01/01/2010 |
    When I go to the dashboard products page

  Scenario Outline: Sort fields
    Then I should see all 4 product
    When I click "<link>" link
    Then <click_second>
    And request query should contain "<search>"
    
    Examples:
      | link | search                      | click_second       |
      | EAN  | search[meta_sort]=ean.asc   | exec "nil"         |
      | EAN  | search[meta_sort]=ean.desc  | I click "EAN" link |
      | Name | search[meta_sort]=name.asc  | exec "nil"         |
      | Name | search[meta_sort]=name.desc | I click "Name" link |
@javascript
   Scenario Outline: Search by name/sku
     And I fill in "search_string" with "<search>"
     And I select "<select>" from "select_by"
     And I on the "search_string" and press enter
     And I should see only "Test product 3" from all products
     And "search_string" should has value "<search>"
     And "select_by" should be selected "<select_value>"

     Examples:
       | search         | select | select_value |
       | Test product 3 | Name   | by_name      |
       | TE-8000        | SKU    | by_sku       |
