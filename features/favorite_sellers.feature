Feature: Manage Favorite Sellers

  Background:
    And I am signed up as "email@person.com/password"
    And the following sellers exist:
      | firstname | email              | password  | password_confirmation |
      | Seller1   | seller1@person.com | password1 | password1             |
      | Seller2   | seller2@person.com | password2 | password2             |

  Scenario: Add seller to favorite
    And I sign in as "email@person.com/password"
    Then exec "@user = User.find_by_email('email@person.com')"
    Then I go to the seller store "seller1@person.com"
    Then I follow "Add Seller To Favorites"
    Then I should not see "Add Seller To Favorites"
    And "seller1@person.com" should be my favorite seller

# @javascript
#   Scenario: Add seller to favorite by non register user
#     Then I go to the seller store "seller1@person.com"
#     Then I follow "Add Seller To Favorites"
#     Then I should not see "Add Seller To Favorites"
#     Then exec "cookies[ActionController::Base.session_options[:favorite_sellers]]"

@javascript
  Scenario: Not show add to favorite seller link
    And I sign in as "email@person.com/password"
    Then exec "@user = User.find_by_email('email@person.com')"
    And I have "seller1@person.com" as favorite seller
    Then I go to the seller store "seller1@person.com"
    Then I should not see "Add Seller To Favorites"

@javascript
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
