# language: en

Feature: Login
  In order to use the site
  A registered user
  Should be able to login


  Scenario Outline: Login with invalid and valid credentials
    Given I am signed up as "email@person.com/password"
    And I try to auth with "<email>" and "<password>"
    Then I should see "<should_see>"
    And I should be on the <page>

    Examples:
      | email            | password    | should_see                | page          |
      | email@person.com | password    | Logged in successfully    | Products page |
      | bad@person.com   | password    | Invalid email or password | sign in page  |
      | email@person.com | badpassword | Invalid email or password | sign in page  |


   Scenario: What I see when I log in
     Given I already sing as "email@person.com/password"
     And I should be on the Products page
     And I should see given in page
     | element    |
     | My Account |
     | Logout     |

  Scenario Outline: Forgot password with valid and invalid email
    Given I am signed up as "email@person.com/password"
    And I am on the sign in page
    Then I follow "Forgot Password?"
    And I should be on reset password page
    And I should see "Forgot Password?" within "h1"
    When I fill in "user_email" with "<email>"
    And press "Reset my password"
    Then I should see "<notice>"
    And I should be on the <page>

    #TODO:
    # Insert notice to bad: Repeat email again. Perhaps you mistake
    Examples:
    | email            | notice                                                                                         | page          |
    | email@person.com | You will receive an email with instructions about how to reset your password in a few minutes. | sign in page  |
    | bad@person.com   |                                                                                                | user password |

  Scenario: Forgot password, send email
    Given I ask a password with valid credentials
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

  Scenario: Change password in admin page
    Given I am signed up as "email@person.com/password"
    When I sign in as "email@person.com/password"
    And I follow "My Account"
    Then I should be on the "email@person.com" account page
    Then I should see "My Account"
    Then I follow "Change Password"
    Then I should be on the current user edit password page
    And I fill in "Current Password" with "password"
    And I fill in "New Password" with "moloko"
    And I fill in "Repeat Password" with "moloko"
    And I press "Update"
    Then I should be on the dashboard account fuck page
    And I should see "Password updated"
