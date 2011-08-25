# language: en

Feature: Purachases
  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as "email@person.com/password"
    And 1 payment methods exist
    And 1 bogus payment methods exist
    And the following sellers exist:
      | firstname | lastname | email              | password  | password_confirmation |
      | Seller1   | Nil1     | seller1@person.com | password1 | password1             |
      | Seller2   | Nil2     | seller2@person.com | password2 | password2             |
      | Seller3   | Nil3     | seller3@person.com | password3 | password3             |
    And the following products exist:
      | name                        |            ean | created_at | owner                    |
      | The Godfather               |  9780099528128 | 01/01/2011 | email:seller1@person.com |
      | Death of a Hero [Paperback] | 978-0919614789 | 01/01/2010 | email:seller1@person.com |
    And the following variants exist:
      | product                          | seller                   | price | condition | count_on_hand | owner                    |
      | name:The Godfather               | email:seller1@person.com |  12.0 | new       |             6 | email:seller1@person.com |
      | name:The Godfather               | email:seller2@person.com |  14.0 | new       |             5 | email:seller2@person.com |
      | name:The Godfather               | email:seller3@person.com |  10.0 | used      |            10 | email:seller3@person.com |
      | name:Death of a Hero [Paperback] | email:seller1@person.com | 22.89 | new       |             7 | email:seller1@person.com |
      | name:Death of a Hero [Paperback] | email:seller2@person.com | 24.50 | new       |             4 | email:seller2@person.com |
      | name:Death of a Hero [Paperback] | email:seller3@person.com |  20.0 | used      |            10 | email:seller3@person.com |
    And  the following shipping methods exist:
      | seller                   | name        |
      | email:seller2@person.com | UPS Ground1 |
      | email:seller1@person.com | UPS Ground2 |
      | email:seller3@person.com | UPS Ground3 |

  Scenario: Viewing purachases list
    Given the user "email@person.com" has the order with number "RT4578" and date "01/01/2010 00:00":
      | product                     | seller             | quantity | price |
      | The Godfather               | seller1@person.com |        2 |  12.0 |
      | Death of a Hero [Paperback] | seller3@person.com |        3 |  20.0 |
     When I sign in as "email@person.com/password"
     And I go to the dashboard purchases page
     Then the page have the following purchases list:
      | product                     | seller       | order_date        | order_number | amount |
      | The Godfather               | Seller1 Nil1 | December 31, 2009 | RT4578       | $24.00 |
      | Death of a Hero [Paperback] | Seller3 Nil3 | December 31, 2009 | RT4578       | $60.00 |


  Scenario: Check weight rate
    Given the user "email@person.com" has the order with number "RT4578" and date "01/01/2010 00:00":
      | product                     | seller             | quantity | price |
      | The Godfather               | seller1@person.com |        2 |  12.0 |
      | Death of a Hero [Paperback] | seller3@person.com |        3 |  20.0 |
    When calculator weight_rate '[{"int":"10","cost":"20"},{"int":"20","cost":"40"}]'
    Then I get shipping adjustment 40 for order "RT4578"
