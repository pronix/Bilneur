Feature: Describe some user/seller data

  Background:
    And I am signed up as a seller with "seller@person.com/password"
    Given I sign in as "seller@person.com/password"

  Scenario: upload seller photo
    Then I go to the dashboard upload_photo page
    And I attach "ruby.png" file with "user_photo"
    Then I press "Save"
    Then I should be on the dashboard account fuck page
    And I should see "Photo updated"
    And I should see that I have "ruby.png" photo
