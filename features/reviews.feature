Feature: Manage reviews

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as a seller with "seller@person.com/password"
    Given the following products was created by  "seller@person.com" user:
      | name                        | available_on        |            ean | sku     |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 | TE-6000 |
      | Death of a Hero [Paperback] | 2011-01-06 18:21:13 | 978-0919614789 | TE-7000 |
    # And the product "The Godfather" has the owner "seller@person.com"
    # And the product "Death of a Hero [Paperback]" has the owner "admin@person.com"  
@wip
  @javascript
  Scenario: Show product rating
    When I go to the "The Godfather" product page

