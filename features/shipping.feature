# language: en
Feature: Shipping
  Scenario: Check order calculation
    Given exist order with full weight 11
    And exist order with full weight 1
    And exist shipping methods with calculator weight_rate
    And configured interval '[{"int":"10","cost":"20"},{"int":"20","cost":"40"}]'
    When I set weight_based shipping method to order with weight 11
    Then I get shipping adjustment 40
    When I set weight_based shipping method to order with weight 1
    Then I get shipping adjustment 20
