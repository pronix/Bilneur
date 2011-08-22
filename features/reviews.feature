Feature: Manage reviews

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as a seller with "seller@person.com/password"
    Given I have product with name "The Godfather" and owner "seller@person.com"
    # Given I have "2" reviews for product "The Godfather" with rating "4" and approved
    # Given the guest can not create a review
    Given I sign in as "seller@person.com/password"
    # And create sample paypal paymethod

  Scenario: Show product rating
    When I go to the "The Godfather" product page
    Then I should see "The Godfather"
    And I should see overall rating with "4" stars
    And I should see Baserd on some Rating
    And I should see all approved reviews for "The Godfather" product

@javascript
  Scenario: Show reviews in seller panel
    And I have 4 unapproved and 2 approved reviews for product "The Godfather"
    Then I go to the account page
    And I should be on the account page
    And I follow "Feedback"
    And I follow "My Product reviews"
    Then selectbox "approved_select_hz" should be selected for "All"
    Then selectbox "select_product_id" should be selected for "All"
    And I should see all 6 review for product "The Godfather"
@javascript  
  Scenario Outline: Show only approved/unapproved review in seller panel  
    And I have 4 unapproved and 2 approved reviews for product "The Godfather"
    Then I go to the reviews dashboard page
    And I follow "My Product reviews"
    Then I select "<select>" from "approved_select_hz"
    And I should see only approved "<status>" reviews

    Examples:
    | select     | status |
    | Approved   | true   |
    | Unapproved | false  |


  Scenario: Approve some review
    Given I sign in as "seller@person.com/password"
    And create sample paypal paymethod
    Given I have a unapproved review for "The Godfather" and call it @review
    Then I go to the "The Godfather" product page
    And I should not see @review on the product page
    Then I go to the reviews dashboard page
    And I should see @review on the reviews dashboard page
    Then I apprved @review by click "Approve"
    Then I go to the "The Godfather" product page
    And I should see @review on the product page

  Scenario: Only one time register user can write review for one product
    Given I am signed up as a seller with "seller3@person.com/password"
    Given I sign in as "seller3@person.com/password"
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

  #FIXME 
  # Scenario: Create review as Guest
  #   And I am logged out
  #   Then test
  #   When I go to the "The Godfather" product page
  #   Then I follow "Rate This Product"
  #   And I should be on the login page

  Scenario: Create review as register user
    Given I already sing as "new_seller@person.com/password"
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
    And I should see my name "Test Firstname T." with my review
    And I should see my photo as "new_seller@person.com"

 Scenario: Review admin configuration
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
   Given I have spree preference "include_unapproved_reviews" with "true"
   Given I am signed and create review
