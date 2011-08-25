# language: en

Feature: Manage Favorite Products

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as "email@person.com/password"
    And 1 bogus payment methods exist
    And the following sellers exist:
      | firstname | email              | password  | password_confirmation |
      | Seller1   | seller1@person.com | password1 | password1             |
      | Seller2   | seller2@person.com | password2 | password2             |
      | Seller3   | seller3@person.com | password3 | password3             |
    And the following products exist:
      | name                        |            ean | created_at | owner                    | is_master |
      | The Godfather               |  9780099528128 | 01/01/2011 | email:seller1@person.com | true      |
      | Death of a Hero [Paperback] | 978-0919614789 | 01/01/2010 | email:seller1@person.com |    true   |
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


