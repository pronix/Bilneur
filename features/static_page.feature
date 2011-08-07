Feature: Work with static pages

  Background:
    # Given I sing as "admin" with credentials "admin@example.com/password"
    Given I already sing as "admin@example.com/password" with "admin" role
    And I am on the admin page

  Scenario: Create new admin page
    # Sceanrio when we on admin page, DON'T USE CUCUMBER FROM SPORK!
    Then I follow "Pages"
    And I should be on the admin static page
    And I should see "Static pages"
    Then I follow "New page"
    And I should be on the new admin static page
    And I fill in "Title" with "Test Page Number One"
    And I fill in "Slug" with "test-page-number-one"
    And I fill in "Body" with "This is only test page, for cucumber"
    And press "Create"
    Then I should be on the admin static page
    And I should see "Page has been successfully created!"
    And I should see "Test Page Number One"

  Scenario: Test new static page
    Given I have static page "Bugaga/this-is-url/This is body for static page"
    Then I visit "/this-is-url"
    And I should be on the static page "this-is-url"
    And I should see "Bugaga"
    And I should see "This is body for static page"
