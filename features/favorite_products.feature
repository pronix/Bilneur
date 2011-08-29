# language: en

Feature: Manage Favorite Products

  Background:
    Given load test data

  @javascript
  Scenario: Adding & remove product to favorite panel
    When I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    Then I should be on the cart page
    And page not have Saved Items panel
    When I follow "Save for later"
    Then I should be on the cart page
    And I should see "Product saved."
    And page have Saved Items panel with the following products:
     | The Godfather |
    When I follow "Remove" within "#your_saved_items"
    Then page not have Saved Items panel

  Scenario: Adding product to cart from favorite panel
    When I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    Then I should be on the cart page
    And page not have Saved Items panel
    When I follow "Save for later"
    Then I should be on the cart page
    And I should see "Product saved."
    And page have Saved Items panel with the following products:
     | The Godfather |
    When I press "Add To Cart" within "#your_saved_items"
    Then I should be on the cart page
    And the cart include the product "The Godfather" with quantity "4"

  Scenario: Adding product to virtual cart from favorite panel
    When I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    Then I should be on the cart page
    And page not have Saved Items panel
    When I follow "Save for later"
    Then I should be on the cart page
    And I should see "Product saved."
    And page have Saved Items panel with the following products:
     | The Godfather |
    When I press "Add To V.Store" within "#your_saved_items"
    Then I should be on the cart page
    And the virtual cart include the product "The Godfather" with quantity "1"

  Scenario: Saving favorite products after sign in buyer
    When I go to the "The Godfather" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller2@person.com"
    And I press "Add To Cart" within block seller "seller2@person.com"
    Then I should be on the cart page
    And page not have Saved Items panel
    When I follow "Save for later"
    Then I should be on the cart page
    And I should see "Product saved."
    And page have Saved Items panel with the following products:
     | The Godfather |
    When I sign in as "email@person.com/password"
    And I go to the cart page
    Then page have Saved Items panel with the following products:
     | The Godfather |
    When I follow "Logout"
    And I go to the cart page
    And page not have Saved Items panel
    When I go to the "Death of a Hero [Paperback]" product page
    And I follow "View All"
    And I set quatility "3" within block seller "seller1@person.com"
    And I press "Add To Cart" within block seller "seller1@person.com"
    Then I should be on the cart page
    And page not have Saved Items panel
    When I follow "Save for later"
    Then I should be on the cart page
    And I should see "Product saved."
    And page have Saved Items panel with the following products:
     | Death of a Hero [Paperback] |
    When I sign in as "email@person.com/password"
    And I go to the cart page
    Then page have Saved Items panel with the following products:
     | Death of a Hero [Paperback] |
     | The Godfather               |


