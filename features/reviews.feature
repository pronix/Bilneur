@wip
Feature: Manage reviews

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as a seller with "seller@person.com/password"
    Given I have product with name "The Godfather" and owner "seller@person.com"
    Given I sign in as "seller@person.com/password"

  Scenario: Show product rating
    Given I have "2" reviews for product "The Godfather" with rating "4" and approved
    When I go to the "The Godfather" product page
    Then I should see "The Godfather"
    And I should see overall rating with "4" stars
    And I should see Baserd on some Rating
    And I should see all approved reviews for "The Godfather" product

@javascript
  Scenario: Show Feedback page
    Then I go to the dashboard account fuck page
    And I follow "Feedback"
    Then I should see "Feedback as a Buyer"
    Then I should see "Feedback as a Seller"
    Then I should see "Feedback Left"
    Then I should see "My Product reviews"

@javascript
  Scenario: Show My Product Review in seller panel
    And I have 4 unapproved and 2 approved reviews for product "The Godfather"
    Then I go to the reviews dashboard page
    And I follow "My Product reviews"
    Then selectbox "approved_select_hz" should be selected for "All"
    Then selectbox "select_product_id" should be selected for "All"
    And I should see all 6 review for product "The Godfather"

@javascript
  Scenario Outline: Show only approved/unapproved review on the My Product Review
    And I have 4 unapproved and 2 approved reviews for product "The Godfather"
    Then I go to the reviews dashboard page
    And I follow "My Product reviews"
    Then I select "<select>" from "approved_select_hz"
    And I should see only approved "<status>" reviews

    Examples:
    | select     | status |
    | Approved   | true   |
    | Unapproved | false  |

@javascript
  Scenario: Approve some reviews on the My Product Review
    And I have 4 unapproved and 2 approved reviews for product "The Godfather"
    Then I go to the reviews dashboard page
    And I follow "My Product reviews"
    Then I click "Approve" for all unapproved review
    Then I should not see "Approve" link in the reviews
    Then I should not have unapproved reviews

@javascript
  Scenario: Show My Product Review only for one product
    Given I have product with name "The Second Product" and owner "seller@person.com"
    And I have 4 unapproved and 2 approved reviews for product "The Godfather"
    And I have 4 unapproved and 2 approved reviews for product "The Second Product"
    Then I go to the reviews dashboard page
    And I follow "My Product reviews"
    Then I select "The Second Product" from "select_product_id"
    And I should see only reviews for "The Second Product"

@javascript
  Scenario: Delete some review
    And I have 4 unapproved and 2 approved reviews for product "The Godfather"
    Then I go to the reviews dashboard page
    And I follow "My Product reviews"
    And I delete 2 reviews
    And I should have 4 reviews

  Scenario: Only one time register user can write review for one product
    Then I go to the "The Godfather" product page
    And I follow "Rate This Product"
    And I should be on the new review page for product "The Godfather"
    And I rate this by "3"
    And I fill in "review_review" with "Simple Review 33"
    And I press "Submit your review"
    And I should be on the "The Godfather" product page
    And I should not see link "Rate This Product"

  Scenario: Disable link /product/review
    When I go to the "The Godfather" review by url
    And I should be on the "The Godfather" product page

  Scenario: Show latest review for "The Godfather" product in last review block
    When I go to the "The Godfather" product page
    Then I should see lates review for "The Godfather" on last review block

 Scenario: Create review as register user
    When I go to the "The Godfather" product page
    Then I follow "Rate This Product"
    And I rate this by "3"
    And I fill in "review_review" with "Simple Review"
    And I press "Submit your review"
    And please define last Review by review "Simple Review" as @review
    And I should be on the "The Godfather" product page
    And I should see "Review was successfully submitted"
    Then I approved my review
    Then I go to the "The Godfather" product page
    And I should see my fuck review

 Scenario: Review admin configuration
   And I am logged out
   Given I sign in as "admin@person.com/password"
   Then I go to the admin main page
   Then I follow "Configuration"
   Then I follow "Review Settings"
   And I should be on the admin review setting page
   Then I follow "Edit"
   And I should be on the edit admin review setting page
   And I check "preferences[require_login]"
   Then press "Update"
   And I should be on the admin review setting page

 Scenario: If Review option include_unapproved_reviews true
   And I am logged out
   Given I have spree preference "include_unapproved_reviews" with "true"
   Given I am signed and create review
