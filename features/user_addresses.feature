# language: en

Feature: User Addresses

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as a seller with "seller@person.com/password"
    And user "seller@person.com" has the following attributes:
      | firstname | Bob    |
      | lastname  | Spanch |
    And load default data

  Scenario: Adding the address
    When I sign in as "seller@person.com/password"
    And I go to the new dashboard address page
    And I fill in "Street Address" with "St 2 Br"
    And I fill in "City" with "New Yourk"
    And I fill in "address_state_name" with "Idaho"
    And I fill in "Zip" with "346849"
    And I select "United States" from "Country"
    And I fill in "Phone" with "56-434744-43434"
    And I press "Create"
    Then I should see "Address has been successfully created!"
    And page should have the following addresses:
    | Address                                                      |
    | Bob Spanch: 346849, United States, Idaho, New Yourk, St 2 Br |

  Scenario: Editing the address
    Given user "seller@person.com" have the following addresses:
      | 346849, United States, Idaho, New Yourk, St 2 Br |
    When I sign in as "seller@person.com/password"
    And I go to the dashboard addresses page
    And I follow "Edit"
    And I fill in "Street Address" with "St 4 Br"
    And I press "Update"
    Then I should see "Address has been successfully updated!"
    And page should have the following addresses:
    | Address                                                      |
    | Bob Spanch: 346849, United States, Idaho, New Yourk, St 4 Br |

  @javascript
  Scenario: Destroy the address
    Given user "seller@person.com" have the following addresses:
      | 346849, United States, Idaho, New Yourk, St 2 Br |
    When I sign in as "seller@person.com/password"
    And I go to the dashboard addresses page
    And I follow "Remove" and click OK
    Then I should see "Address has been successfully destroyed!"


