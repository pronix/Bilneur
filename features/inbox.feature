Feature: Inbox
  Users can exchange messages

  Background:
  Given I am signed up as "email1@person.com/password"
  Given I have an admin account of "admin@person.com/password"
  And the following users exist:
    | firstname | lastname | email            | password | password_confirmation |
    | Jimm      | Paxtor   | email@person.com | password | password              |
  And the following sellers exist:
    | firstname | email              | password  | password_confirmation |
    | Seller1   | seller1@person.com | password1 | password1             |
# @wip @javascript
#   Scenario Outline: Change move to in the show message
#     And I sign in as "email1@person.com/password"
#     And I have 1 simple message when I is recipient
#     Then I go to the @message message page
#     Then sleep "10"
#     And I select "<mark_as>" from "websites21"
#     And @message should be "<field>" is "<should_be>"

#     Examples:
#      | mark_as        | field          | should_be |
#      | Mark as read   | recipient_read | true      |
#      | Mark as unread | recipient_read | false     |
#      | Mark as important | recipient_marker | important |
    

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
     | from        | subject   | received         | 
     | Jimm Paxtor | Question1 | January 01, 2011 | 
    When I follow "Question1"
    Then I should be on the show dashboard message page for "Question1"
    And show me the page
    And I should see "Jimm Paxtor"
    And I should see "Seller1"
    And I should see "January 01, 2011 00:00"
    And I should see "Question1 message"
    And the page should have text area for reply
    And I should see "Send"
@javascript
  Scenario: Replying to a message
    Given the following messages exist:
     | created_at | sender                 | recipient                | subject   | content           |
     | 01/01/2011 | email:email@person.com | email:seller1@person.com | Question1 | Question1 message |
    When I sign in as "seller1@person.com/password1"
    And I go to the dashboard messages page
    Then the page should have the following messages:
     | from        | subject   | received         |
     | Jimm Paxtor | Question1 | January 01, 2011 |
    When I follow "Question1"
    Then I execute script "active reply"
    And I fill in "message_content" with "Thanks for you Question."
    And I press "Send"
    Then I should see "Your reply sent."

@javascript
  Scenario Outline: Marking message as read/unread
    Given the following messages exist:
     | created_at | sender                 | recipient                | subject   | content           | recipient_read |
     | 01/01/2011 | email:email@person.com | email:seller1@person.com | Question1 | Question1 message | <read_status>  |
    When I sign in as "seller1@person.com/password1"
    And I go to the dashboard messages page
    Then the page should have the following messages:
     | from        | subject   | received         |
     | Jimm Paxtor | Question1 | January 01, 2011 |
    When I check "message_ids[]"
    Then I execute script "<page_script_execute>"
    And I wait for the AJAX call to finish
    And message by subject "Question1" should be "recipient_read" is <message_status>

    Examples:
      | read_status | page_script_execute  | message_status |
      | false       | inbox send_as_read   | true           |
      | true        | inbox send_as_unread | false          |

@javascript
  Scenario Outline: Marking message as delete/impornat
    Given the following messages exist:
     | created_at | sender                 | recipient                | subject   | content           |
     | 01/01/2011 | email:email@person.com | email:seller1@person.com | Question1 | Question1 message |
    When I sign in as "seller1@person.com/password1"
    And I go to the dashboard messages page
    Then the page should have the following messages:
     | from        | subject   | received         |
     | Jimm Paxtor | Question1 | January 01, 2011 |
    When I check "message_ids[]"
    Then I execute script "<page_script_execute>"
    And I wait for the AJAX call to finish
    And message by subject "Question1" should be "<field>" a present
    
    Examples:
      | page_script_execute     | field                |
      | inbox send_delete       | recipient_deleted_at |
      | inbox send_as_important | recipient_marker     |

@javascript    
  Scenario: Mark all message as read
    Given the following messages exist:
     | created_at | sender                 | recipient                | subject   | content           |
     | 01/01/2011 | email:email@person.com | email:seller1@person.com | Question1 | Question1 message |
     | 01/01/2011 | email:email@person.com | email:seller1@person.com | Question2 | Question2 message |
    When I sign in as "seller1@person.com/password1"
    And I go to the dashboard messages page
    Then the page should have the following messages:
     | from        | subject   | received         |
     | Jimm Paxtor | Question1 | January 01, 2011 |
     | Jimm Paxtor | Question2 | January 01, 2011 |
    Then I execute script "inbox select_all_messages"
    Then I execute script "inbox send_as_read"
    And I wait for the AJAX call to finish
    And All my message should be read
