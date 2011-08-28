# language: en
Feature: Seller payment methods

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as a seller with "seller@person.com/password"
    And user "seller@person.com" has no payment methods
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
     | Name      | Payment Type | Verified                                       |                            |
     | My paypal | Paypal       | unverified\n              send to verification | edit\n              delete |

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
     | Name           | Payment Type | Verified                                       |                            |
     | My credit card | Credit Card  | unverified\n              send to verification | edit\n              delete |
    When I follow "My credit card"
    Then I should see "Method type: Credit Card"
    And I should see "Name: My credit card"
    And I should see "State: unverified"
    And I should see "Card Type: visa"
    And I should see "Code: 1234 1234 1234 1234"
    And I should see "CVV: 234"
    And I should see "Expiration: 12/13"
    And I should see "Billing Address: xyz street, san jose, ca"


  Scenario: Add Payment Method(Bank Account)
    Given I go to the dashboard payment_methods page
    And I follow "New Payment Method"
    And I select "Bank Account" from "Type"
    And I fill in "Name" with "My Bank Account"
    And I press "Create"
    When I fill in "Bank" with "Bank of America"
    And I fill in "Routing Number" with "2345678"
    And I fill in "Account Number" with "45678890"
    And I press "Update"
    Then I should see "Payment Method has been successfully updated!"
    And page have the following payment methods:
     | Name            | Payment Type | Verified                                       |                            |
     | My Bank Account | Bank Account | unverified\n              send to verification | edit\n              delete |
    When I follow "My Bank Account"
    Then I should see "Method type: Bank Account"
    And I should see "Name: My Bank Account"
    And I should see "State: unverified"
    And I should see "Bank: Bank of America"
    And I should see "Routing Number: 2345678"
    And I should see "Account Number: 45678890"

