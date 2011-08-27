# language: en

Feature: Order tracking

  Background:
    Given load test data
    And the user "email@person.com" has the order with number "RT4578" and date "01/01/2010 00:00":
      | product                     | seller             | quantity | price |
      | The Godfather               | seller1@person.com |        2 |  12.0 |
      | Death of a Hero [Paperback] | seller3@person.com |        3 |  20.0 |
    And the user "email@person.com" choose the following shipping methods for order "RT4578":
      | seller             | shipping    |
      | seller1@person.com | UPS Ground2 |
      | seller3@person.com | UPS Ground3 |

  Scenario: Adding tracking number
    When I sign in as "seller1@person.com/password1"
    And I go to the dashboard sales page
    Then page have the following orders:
      | Order  | Order Date | Status   | Buyer                        | Payment     | Shipment | Tracking No | Total  |              |
      | RT4578 | 2009-12-31 | Complete | Test Firstname Test Lastname | balance due | pending  |             | $34.00 | Add Tracking |
    When I follow "Add Tracking"
    And I fill in "Number" with "17efz789"
    And I press "Save"
    Then I should see "Tracking updated."
    And  page have the following orders:
      | Order  | Order Date | Status   | Buyer                        | Payment     | Shipment | Tracking No | Total  |              |
      | RT4578 | 2009-12-31 | Complete | Test Firstname Test Lastname | balance due | pending  | 17efz789    | $34.00 | Add Tracking |

