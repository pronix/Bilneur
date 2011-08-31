# language: en

Feature: Manage products
  Seller: adding, editing, deleting products

  Background:
    Given I have an admin account of "admin@person.com/password"
    Given I am signed up as a seller with "seller@person.com/password"
    When I sign in as "seller@person.com/password"
    Given the following taxonomies exist:
      | name       |
      | Books      |
      | Movie      |
      | Categories |

  Scenario: Adding new a product
    When I go to the dashboard quotes page
    And I fill in "ean" with "WEYD:FKKK"
    And I press "Add quote"
    Then I should be on the new dashboard product page
    When I fill in "Name" with "Breakfast At Tiffany's - Paramount Centennial Collection (Mastered in High Definition) (1961)"
    And I fill in "product_ean" with "5055055903603"
    And I fill in "Description" with "No film better utilizes Audrey Hepburn's"
    And I press "Create"
    Then I should see "Product is created."

  Scenario: Editing the product
    Given the following products exist:
      | name                        | available_on        |            ean | sku     | created_at |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 | TE-6000 | 01/01/2011 |
      | Death of a Hero [Paperback] | 2011-01-06 20:21:13 | 978-0919614789 | TE-7000 | 01/01/2010 |
    And the product "The Godfather" has the owner "seller@person.com"
    And the product "Death of a Hero [Paperback]" has the owner "admin@person.com"
    When I go to the dashboard products page
    Then I should see the following product lists:
      | SKU     |            EAN | Name                        |                                |
      | TE-6000 |  9780099528128 | The Godfather               | Edit\n         \n       Delete |
      | TE-7000 | 978-0919614789 | Death of a Hero [Paperback] |                                |
    When I follow "Edit"
    And I fill in "SKU" with "TFWK"
    And I fill in "Name" with "The Godfather_1"
    And I press "Update"
    Then I should see "Product updated."
    And  I should see the following product lists:
      | SKU     |            EAN | Name                        |                                |
      | TFWK    |  9780099528128 | The Godfather_1             | Edit\n         \n       Delete |
      | TE-7000 | 978-0919614789 | Death of a Hero [Paperback] |                                |


  Scenario: Add Quote
    Given the following products exist:
      | name                        | available_on        |            ean | sku     |
      | The Godfather               | 2011-01-06 18:21:13 |  9780099528128 | TE-6000 |
      | Death of a Hero [Paperback] | 2011-01-06 18:21:13 | 978-0919614789 | TE-7000 |
    When I go to the dashboard quotes page
    And I fill in "ean" with "978-0919614789"
    And I press "Add quote"
    When I fill in "variant_price" with "45.98"
    And I fill in "variant_count_on_hand" with "4"
    And I fill in "variant_weight" with "0.4"
    And I press "Create"
