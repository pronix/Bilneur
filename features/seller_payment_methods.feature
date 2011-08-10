# language: en
@focus
Feature: Seller payment methods

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as a seller with "seller@person.com/password"
    And user "seller@person.com" has the following attributes:
     | firstname | Bob    |
     | lastname  | Spanch |
    And load default data
    When I sign in as "seller@person.com/password"

  Scenario: Add Payment Method(Paypal)
    Given I go to the dashboard payment_methods page
    And I follow "New Payment Method"
    And I select "Paypal" from "Type"
    And I fill in "Name" with "My paypal"
    And I press "Create"
    When I fill in "Login" with "test_paypal@tpay.com"
    And I fill in "Password" with "password"
    And I press "Update"
    Then I should see "Payment Method has been successfully updated!"
    And page have the following payment methods:
     | Name      | Payment Type | Verified                                 |                      |
     | My paypal | Paypal       | unverified\n        send to verification | edit\n        delete |

  Scenario: Add Payment Method(Credit Card)
    Given I go to the dashboard payment_methods page
    And I follow "New Payment Method"
    And I select "Credit Card" from "Type"
    And I fill in "Name" with "My credit card"
    And I press "Create"
    When I fill in "Card Type" with "visa"
    And I fill in "Code" with "1234 1234 1234 1234"
    And I fill in "CVV" with "234"
    And I fill in "Billing Address" with "xyz street, san jose, ca"
    And I fill in "Expiration" with "12/13"
    And I press "Update"
    Then I should see "Payment Method has been successfully updated!"
    And page have the following payment methods:
     | Name           | Payment Type | Verified                                 |                      |
     | My credit card | Credit Card  | unverified\n        send to verification | edit\n        delete |
    When I follow "My credit card"
    Then I should view credit card info:
     | name            | My  credit card            |
     | card type       | Credit Card                |
     | cvv             | CVV: 234                   |
     | code            | Code: 234                  |
     | expiration      | 12/13                      |
     | billing address | "xyz street, san jose, ca" |



  Scenario: My Account Panel and Account setting - Payment panel
    Given that iam in in My Account Page and in Account Setting panel
    Given that i am in “Add A Payment Type” panel
    And i should see option “Credit card”, “Paypal” and  “Bank Account”
    And i select option “Credit Card”
    And i should see | type | card number | exp            |cvv|  billing address|
    And i fill with	 | visa | 1234 1234 1234 1234| 12/13 |234 |xyz street, san jose, ca |
    And i press “Save”
    Then the “Credit card” information  |visa |1234 1234 1234 1234|12/13|234|xyz street, san jose, ca | Under “payments” panel

  Scenario: My Account Panel and Account setting - Payment panel- Paypal account
    Given that i am in My Account Page and in Add A Payment Type panel
    And i selected “ Paypal Account”
    Given that my Paypal login is “login” “myname@gmail.com” and “password” is “mypassword”
    And i should see “Login” and i fill with  “ myname@gmail.com”
    And i should see “Password” and i fill with “mypassword”
    And i press “save
    Then in the payment panel i should see “paypal” selected and is should see “login” “myname@gmail.com” and “password” is “mypassword”

  Scenario: My Account Panel and Account setting - Payment panel- Bank account
    Given that i am in My Account Page and in Add A Payment Type panel
    And i selected “ Bank Account”
    Given the “Bank Account” Information “Bank” “Bank of America”, “Routing number”“2345678”, “Account Number” ‘45678890
    And i should see “Bank” and i fill with “Bank of america”
    And i should see “Routing no” and i fill with “ 2345678”
    And i should see “Account number” and i fill with “45678890”
    And i press “save”
    Then i should see “Bank account” selected and
    And i should see “Bank” “Bank of America”, “Routing number” 2345678”, Account Number” “45678890”
