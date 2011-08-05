# language: en
@wip
Feature: Verifying sellers

  Background:
    Given there are the following products:
    | name     | description       | taxonomy        | condition | brand   | seller     | price | tier_price                    |
    | laptopA  | new Laptop        | computer>laptop | new       | HP      | sellerA    |   500 | 1-10:500;11-20:480            |
    | laptopB  | used Laptop       | computer>laptop | used      | HP      | sellerA    |   200 | 1-10:200;11-20:180            |
    | laptopC  | new Laptop        | computer>laptop | new       | sony    | sellerB    |   700 | 1-10:200;11-20:180            |
    | camera   | dc                | electr>dc       | new       | Sony    | SellerB    |   100 |                               |
    | mouseA   | wireless mouse    | computer>acc    | new       | Logic   | innovity   | 19.99 | 1-10:19.8;11-20:15.99         |
    | mouseB   | normal mouse      | computer>acc    | used      | Logic   | innovity   |  2.99 | 1-20:2.8;21-:1.99             |
    | mouseC   | wireless mouse    | computer>acc    | used      | rapoo   | big_seller | 10.99 | 1-10:10.8;11-20:9.19;21-:8.99 |
    | keyboard | wireless keyboard | computer>acc    | new       | visenta | myname     | 40.00 | 1-10:39;11-20:34              |

  Scenario: Verifying sellers account
    Given that start selling menu button is available in all the pages
    And i press "Start selling"
    Given i am not logged in
    Then I should be in login page
    And I fill username "myname"
    And I fill password "mypassword"
    And I press submit button
    Given the payment method is none
    Then I should see profile page with payment panel
    And I fill in type "credit card" card number "1234 1234 1234 1234" , exp "12/09/13" cvv "123"
    And press "Enter"
    Then I should see in my dashboard, selling tab, inventory tab.
