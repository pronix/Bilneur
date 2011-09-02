Feature: Manage Favorite Sellers

  Background:
    And I am signed up as "email@person.com/password"
    And the following sellers exist:
      | firstname | email              | password  | password_confirmation |
      | Seller1   | seller1@person.com | password1 | password1             |
      | Seller2   | seller2@person.com | password2 | password2             |
      | Seller3   | seller3@person.com | password2 | password2             |
      | Seller4   | seller4@person.com | password2 | password2             |

@javascript
  Scenario: Add seller to favorite as register user
    And I sign in as "email@person.com/password"
    Then exec "@user = User.find_by_email('email@person.com')"
    Then I go to the seller store "seller1@person.com"
    Then I follow "Add Seller To Favorites"
    Then I should not see "Add Seller To Favorites"
    And "seller1@person.com" should be my favorite seller
    And I should see "Seller has been added to favorites."
    Then I go to the seller store "seller1@person.com"
    Then I should not see "Add Seller To Favorites"

@announce
  Scenario: Add seller to favorite by non register user
    Then I go to the seller store "seller1@person.com"
    Then I follow "Add Seller To Favorites"
    Then I should not see "Add Seller To Favorites"
    Then I go to the seller store "seller1@person.com"
    Then I should not see "Add Seller To Favorites"
    And I sign in as "email@person.com/password"
    And "seller1@person.com" should be my favorite seller
    # Flag @announce and this code need for close browser when test with @javascript 
    Then I close my browser

  Scenario: Show my favorite sellers on the dashboard page
    And I sign in as "email@person.com/password"
    And I have following sellers as favorite:
      | email              |
      | seller2@person.com |
      | seller3@person.com |
      | seller4@person.com |
    Then I go to the favorite sellers dashboard page
    And I should all 3 favorite sellers

  Scenario: Not show favorite link on my page
    And I sign in as "seller1@person.com/password1"
    Then I go to the seller store "seller1@person.com"
    Then I should not see "Add Seller To Favorites"
@javascript
  Scenario: Delete seller from favorite
    And I sign in as "email@person.com/password"
    And I have following sellers as favorite:
      | email              |
      | seller2@person.com |
    Then I go to the favorite sellers dashboard page
    And I follow "Delete"
    And I should not see "Delete"
    And I should not see favorite seller "seller2@person.com" "full_name" on the page
    And I should not have "seller2@person.com" as my favorite seller

  Scenario: Not show add to favorite seller link
    And I sign in as "email@person.com/password"
    Then exec "@user = User.find_by_email('email@person.com')"
    And I have "seller1@person.com" as favorite seller
    Then I go to the seller store "seller1@person.com"
    Then I should not see "Add Seller To Favorites"


  Scenario: Add more that one favorite seller
    And I sign in as "email@person.com/password"
    Then exec "@user = User.find_by_email('email@person.com')"
    Then I go to the seller store "seller1@person.com"
    Then I follow "Add Seller To Favorites"
    Then I should not see "Add Seller To Favorites"
    Then I go to the seller store "seller2@person.com"
    Then I follow "Add Seller To Favorites"
    Then I should not see "Add Seller To Favorites"
    And I should have 2 favorite sellers
