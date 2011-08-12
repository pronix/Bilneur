# language: en

Feature: Inbox
  Users can exchange messages

  Background:
  Given I have an admin account of "admin@person.com/password"
    And I am signed up as "email@person.com/password"
    And the following sellers exist:
      | firstname | email              | password  | password_confirmation |
      | Seller1   | seller1@person.com | password1 | password1             |

  Scenario: Sending Message access only auth user
    When I go to the new message page for seller "seller1@person.com"
    Then I should be on the sign in page

  Scenario: Sending Message
    When I sign in as "email@person.com/password"
    And I go to the new message page for seller "seller1@person.com"
    And I fill in "Subject" with "Question on your product"
    And I fill in "Content" with "Message content"
    And I press "Send"
    Then I should see "Your message sent."
    And "email@person.com" has my message in the Sent
    And user "seller1@person.com" has my message in the Received tab

  @focus
  Scenario: Viewing inbox
    Given the following message exist:
     | created_at | sender          | recipient          | subject   | message           |
     | 01/01/2011 | user@person.com | seller1@person.com | Question1 | Question1 message |
    When I sign in as "seller1@person.com/password"
    And I go to the dashborad inbox page
    Then I should the folowing messages:
     | From            | Subject   | Received   |
     | user@person.com | Question1 | 01/01/2011 |
    When I follow "Question1"
    Then I should be on the show dashboard message page for "Question1"
    And I should see "From: user@person.com"
    And I should see "Received: 01/01/2011"
    And I should see "Message: Question1 message"
    And I should see text area for reply
    And I should see button "Send"

  @wip
  Scenario: Replying to a message
    Given the following message exist:
     | created_at | sender          | recipient          | subject   | message           |
     | 01/01/2011 | user@person.com | seller1@person.com | Question1 | Question1 message |
    When I sign in as "seller1@person.com/password"
    And I go to the dashborad inbox page
    Then I should the folowing messages:
     | From            | Subject   | Received   |
     | user@person.com | Question1 | 01/01/2011 |
    When I follow "Question1"
    And I fill in "Reply" with "Thanks for you Question."
    And I press "Send"
    Then I should see "Message sent"

  @wip
  Scenario: Marking message as read
    Given the following messages exist:
     | created_at | sender          | recipient          | subject   | message           |
     | 01/01/2011 | user@person.com | seller1@person.com | Question1 | Question1 message |
    When I sign in as "seller1@person.com/password"
    And I go to the dashborad inbox page
    Then I should the folowing messages:
     | From            | Subject   | Received   |
     | user@person.com | Question1 | 01/01/2011 |
    When I check "Question1"
    And I press "Mark as read"
    Then message "Question1" should be mark as 'read'

  @wip
  Scenario: Marking message as unread
    Given the following message exist:
     | created_at | sender          | recipient          | subject   | message           | state |
     | 01/01/2011 | user@person.com | seller1@person.com | Question1 | Question1 message | read  |
    When I sign in as "seller1@person.com/password"
    And I go to the dashborad inbox page
    Then I should the folowing messages:
     | From            | Subject   | Received   |
     | user@person.com | Question1 | 01/01/2011 |
    When I check "Question1"
    And I press "Mark as unread"
    Then message "Question1" should be mark as 'unread'

  @wip
  Scenario: Marking message as important
    Given the following message exist:
     | created_at | sender          | recipient          | subject   | message           |
     | 01/01/2011 | user@person.com | seller1@person.com | Question1 | Question1 message |
    When I sign in as "seller1@person.com/password"
    And I go to the dashborad inbox page
    Then I should the folowing messages:
     | From            | Subject   | Received   |
     | user@person.com | Question1 | 01/01/2011 |
    When I check "Question1"
    And I press "Mark as Important"
    Then message "Question1" should be mark as 'important'

