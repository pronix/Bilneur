Feature: Manage reviews

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as a seller with "seller@person.com/password"
    Given the following products was created by  "seller@person.com" user:
      | name                        | available_on        |            ean |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 |
    Given the following reviews with rating "4" and product "The Godfather" 
      | name   | location | review           | approved | ip_address |
      | Name 1 | here     | This is review   | true     |  127.0.0.1 |
      | Name 2 | here     | Thit is review 2 | true     |  127.0.0.1 |

  Scenario: Disable link /product/review
    When I go to the "The Godfather" review by url
    And I should be on the "The Godfather" product page

  Scenario: Show product rating
    When I go to the "The Godfather" product page
    Then I should see "The Godfather"
    And I should see overall rating with "4" stars
    And I should see "Based On 2 Ratings"
    And I should see all approved reviews for "The Godfather" product

  Scenario: Create review as Guest
    And I am logged out
    When I go to the "The Godfather" product page
    Then I follow "Rate This Product"
    And I should be on the new review page for product "The Godfather"
    And I should see "The Godfather"
    And I rate this by "3"
    And I fill in "review_name" with "Maxim"
    And I fill in "review_review" with "This is simple review"
    And press "Submit your review"
    And please define last Review by review "This is simple review" as @review
    And I should be on the "The Godfather" product page
    And I should see "Review was successfully submitted"
    And I should not see my review on the page
    And I should see that this review add and has status not approved
    And I change status for this review by approved
    Then I go to the "The Godfather" product page
    And I should see my review on the page

  Scenario: Create review as register user
    Given I already sing as "new_seller@person.com/password"
    When I go to the "The Godfather" product page
    Then I follow "Rate This Product"
    And I should not see "Your Name"
    And I rate this by "3"
    And I fill in "review_review" with "Simple Review"
    And I press "Submit your review"
    And please define last Review by review "Simple Review" as @review
    And I should be on the "The Godfather" product page
    And I should see "Review was successfully submitted"
    Then I approved my review
    Then I go to the "The Godfather" product page
    And I should see my review
    And I should see my name "Test Firstname T." with my review
    And I should see my photo as "new_seller@person.com"
