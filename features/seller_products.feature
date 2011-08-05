# language: en

Feature: Manage products
  Seller: adding, editing, deleting products

  Background:
    Given I have an admin account of "admin@person.com/password"
    And I am signed up as a seller with "seller@person.com/password"
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
    Given I have the follow products:
    | name          | taxons |
    | The Godfather | Movie  |

  @wip
  Scenario: Deleting the product


