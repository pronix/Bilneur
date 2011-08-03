# language: en

Feature: Login
  In order to use the site
  A registered user
  Should be able to login
@wip
  Scenario: Login with valid credentials
    Given I am signed up as "email@person.com/password"
    And I am on the sign in page
    And I fill in "Email" with "email@person.com"
    And I fill in "Password" with "password"
    And press "Log In"
    Then I should be on the Products page
    And I should see "Logged in successfully"
    And I should see "My Account"
    And I should see "Logout"

  Scenario: Login with invalid credentials
    Given I am signed up as "email@person.com/password"
    And I am on the sign in page
    And I fill in "Email" with "notmyemail@person.com"
    And I fill in "Password" with "password"
    And press "Log In"
    Then I should see "Invalid email or password"

  Scenario: Login with invalid credentials
    Given I am signed up as "email@person.com/password"
    And I am on the sign in page
    And I fill in "Email" with "notmyemail@person.com"
    And I fill in "Password" with "password"
    And press "Log In"
    Then I should see "Invalid email or password"

  Scenario: Forgot password
    Given I am signed up as "email@person.com/password"
    And I am on the sign in page
    Then I should see "Forgot Password?"
    And I follow "Forgot Password?"
    Then I should see "Forgot Password?" within "h1"
    When I fill in "user_email" with "email@person.com"
    And press "Reset my password"
    Then I should see "You will receive an email with instructions about how to reset your password in a few minutes."
    And a password reset message should be sent to "email@person.com"

  Scenario: Changing the password
    Given I am signed up as "email@person.com/password"
    And I requested password reset
    When I follow the password reset link
    And I fill in "Password" with "newpassword"
    And I fill in "Password confirmation" with "newpassword"
    And press "Update my password and log me in"
    Then I should see "Your password was changed successfully. You are now signed in."

  Scenario: Logout
    Given I am signed up as "email@person.com/password"
    When I sign in as "email@person.com/password"
    And I follow "Logout"
    Then I should see "Log In"
    And I should not see "My Account"
