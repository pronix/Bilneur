Feature: User behavior on home page

Background:
  Given I am non auth user
@wip
  Scenario: What I should see in home page
    When I go to the home page
    Then I should see given link with path
      | link          | link_path        | options        |
      | Sing Up       | the sign up page |                |
      | Log In        | the sign in page |                |
      |               | the sign up page | as_seller=true |
      | Start Selling | the sign up page | as_seller=true |
      
