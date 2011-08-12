# language: en

Feature: Inbox
  Users can exchange messages

  Background:
  Given I have an admin account of "admin@person.com/password"
    And the following users exist:
      | firstname | lastname | email            | password | password_confirmation |
      | Jimm      | Paxtor   | email@person.com | password | password              |
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

  Scenario: Viewing inbox
    Given the following messages exist:
     | created_at | sender                 | recipient                | subject   | content           |
     | 01/01/2011 | email:email@person.com | email:seller1@person.com | Question1 | Question1 message |
    When I sign in as "seller1@person.com/password1"
    And I go to the dashboard messages page
    Then the page should have the following messages:
     | From        | Subject   | Received               |       |
     | Jimm Paxtor | Question1 | January 01, 2011 00:00 | reply |
    When I follow "reply"
    Then I should be on the show dashboard message page for "Question1"
    And I should see "From: Jimm Paxtor to me"
    And I should see "Received: January 01, 2011 00:00"
    And I should see "Message: Question1 message"
    And the page should have text area for reply
    And I should see "Send"

  Scenario: Replying to a message
    Given the following messages exist:
     | created_at | sender                 | recipient                | subject   | content           |
     | 01/01/2011 | email:email@person.com | email:seller1@person.com | Question1 | Question1 message |
    When I sign in as "seller1@person.com/password1"
    And I go to the dashboard messages page
    Then the page should have the following messages:
     | From        | Subject   | Received               |       |
     | Jimm Paxtor | Question1 | January 01, 2011 00:00 | reply |
    When I follow "reply"
    And I fill in "Content" with "Thanks for you Question."
    And I press "Send"
    Then I should see "Your reply sent."

  Scenario: Marking message as read
    Given the following messages exist:
     | created_at | sender                 | recipient                | subject   | content           |
     | 01/01/2011 | email:email@person.com | email:seller1@person.com | Question1 | Question1 message |
    When I sign in as "seller1@person.com/password1"
    And I go to the dashboard messages page
    Then the page should have the following messages:
     | From        | Subject   | Received               |       |
     | Jimm Paxtor | Question1 | January 01, 2011 00:00 | reply |
    When I check "message_ids[]"
    And I press "Mark as read"
    And I follow "Unread"
    Then the page should have the following messages:
     | From | Subject | Received |

  Scenario: Marking message as unread
    Given the following messages exist:
     | created_at | sender                 | recipient                | subject   | content           | recipient_read |
     | 01/01/2011 | email:email@person.com | email:seller1@person.com | Question1 | Question1 message | true           |
    When I sign in as "seller1@person.com/password1"
    And I go to the dashboard messages page
    Then the page should have the following messages:
     | From        | Subject   | Received               |       |
     | Jimm Paxtor | Question1 | January 01, 2011 00:00 | reply |
    When I check "message_ids[]"
    And I press "Mark as unread"
    And I follow "Unread"
    Then the page should have the following messages:
     | From        | Subject   | Received               |       |
     | Jimm Paxtor | Question1 | January 01, 2011 00:00 | reply |


  Scenario: Marking message as important
    Given the following messages exist:
     | created_at | sender                 | recipient                | subject   | content           |
     | 01/01/2011 | email:email@person.com | email:seller1@person.com | Question1 | Question1 message |
    When I sign in as "seller1@person.com/password1"
    And I go to the dashboard messages page
    Then the page should have the following messages:
     | From        | Subject   | Received               |       |
     | Jimm Paxtor | Question1 | January 01, 2011 00:00 | reply |
    And I follow "Important"
    Then the page should have the following messages:
     | From | Subject | Received |
    When I go to the dashboard messages page
    And I check "message_ids[]"
    And I press "Mark as important"
    And I follow "Important"
    Then the page should have the following messages:
     | From        | Subject   | Received               |       |
     | Jimm Paxtor | Question1 | January 01, 2011 00:00 | reply |

