Feature: Search something on the dashboard

  Background:
    Given I am signed up as a seller with "seller@person.com/password"
    When I sign in as "seller@person.com/password"
@wip
  Scenario: Search in dashboard products
    Given the following products exist:
      | name                        | available_on        |            ean | sku     | created_at |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 | TE-6000 | 01/01/2011 |
      | Death of a Hero [Paperback] | 2011-01-06 20:21:13 | 978-0919614789 | TE-7000 | 01/01/2010 |
      | Test product 3              | 2011-01-06 20:21:13 |  828282-221221 | TE-8000 | 01/01/2010 |
      | Test product 4              | 2011-01-06 20:21:13 | 382818202-2222 | TE-9000 | 01/01/2010 |
    When I go to the dashboard products page
    Then I should see all 4 product
    Then I click "SKU"
