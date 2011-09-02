# language: en

Feature: Cart

  Background:
    Given load test data

  Scenario: Cart should be saved after logout user
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    Then I should be on the cart page
    When I follow "Logout"
    And I go to the home page
    When I sign in as "email@person.com/password"
    And I go to the cart page
    Then the cart include the product "The Godfather:seller2@person.com" with quantity "3"

  Scenario: Cart should be merged with prev cart
    When I sign in as "email@person.com/password"
    And I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    Then I should be on the cart page
    When I follow "Logout"
    And I go to the home page
    When I go to the "Death of a Hero [Paperback]" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller1@person.com"
    And I press "Add To Cart" within block seller "seller1@person.com"
    Then I should be on the cart page
    When I sign in as "email@person.com/password"
    And I go to the cart page
    Then the cart include the product "The Godfather:seller2@person.com" with quantity "3"
    And the cart include the product "Death of a Hero [Paperback]:seller1@person.com" with quantity "3"
