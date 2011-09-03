Feature: Describe dashboard permissions

  Background:
    Given I have an admin account of "admin@example.com/password"
    Given I am signed up as "email@person.com/password"
    Given I am signed up as a seller with "seller@person.com/password"


  Scenario Outline: Access table
    And I sign in as "seller@person.com/password"
    Then I open "<path>"
    And access to "<path>" must be "<seller>"
    Then I am logged out

    And I sign in as "email@person.com/password"
    Then I open "<path>"
    And access to "<path>" must be "<user>"

    Then I am logged out
    Then I open "<path>"
    And access to "<path>" must be "<non_register>"

    Examples:
      | path                             | user    | seller  | non_register |
      | /dashboard                       | allowed | allowed | denied       |
      | /dashboard/account               | allowed | allowed | denied       |
      | /dashboard/upload_photo          | allowed | allowed | denied       |
      | /dashboard/account               | allowed | allowed | denied       |
      | /account/change_password         | allowed | allowed | denied       |
      | /dashboard/secrets/edit          | allowed | allowed | denied       |
      | /dashboard/shipping_methods      | allowed | allowed | denied       |
      | /dashboard/addresses             | allowed | allowed | denied       |
      | /dashboard/payment_methods       | allowed | allowed | denied       |
      | /dashboard/sellers/about_you     | denied  | allowed | denied       |
      | /dashboard/sellers/return_policy | denied  | allowed | denied       |
      | /dashboard/inbox                 | allowed | allowed | denied       |
      | /dashboard/purchases             | allowed | allowed | denied       |
      | /dashboard/sales                 | denied  | allowed | denied       |
      | /dashboard/orders                | allowed | allowed | denied       |
      | /dashboard/quotes                | denied  | allowed | denied       |
      | /dashboard/products              | allowed | allowed | denied       |
      | /dashboard/seller_inventories    | denied  | allowed | denied       |
      | /dashboard/reviews               | allowed | allowed | denied       |


  # Scenario Outline: Register User dashboard/products
  #   Given I am signed up <role> "email@person.com/password"
  #   And I sign in as "email@person.com/password"
  #   And I go to the dashboard products page
  #   Then I follow "<link>"
  #   And I should be on the <page>
    
  #   Examples:
  #     | link         | page                        | role             |
  #     | Properties   | dashboard page              | as               |
  #     | Option Types | dashboard page              | as               |
  #     | Properties   | dashboard properties page   | as a seller with |
  #     | Option Types | dashboard option_types page | as a seller with |
    
  # Scenario Outline: Register User main availbale link
  #   Given I am signed up as "email@person.com/password"
  #   And I sign in as "email@person.com/password"
  #   Then I go to the dashboard account fuck page
  #   And I should be on the dashboard account fuck page
  #   Then I click "<link>" link
  #   And I should be on the <page>

  #   Examples:
  #     | link      | page                              |
  #     | Inbox     | dashboard inbox page              |
  #     | Purchases | dashboard purchases page          |
  #     | Selling   | dashboard page                    |
  #     | Orders    | dashboard orders page             |
  #     | Inventory | dashboard page                    |
  #     | Products  | dashboard products page           |
  #     | Stores    | dashboard seller_inventories page |
  #     | Feedback  | dashboard reviews page            |

  # Scenario Outline: Seller main available link
  #   Given I am signed up as a seller with "seller@person.com/password"
  #   And I sign in as "seller@person.com/password"
  #   Then I go to the dashboard account fuck page
  #   And I should be on the dashboard account fuck page
  #   Then I click "<link>" link
  #   And I should be on the <page>

  #   Examples:
  #     | link      | page                              | 
  #     | Inbox     | dashboard inbox page              | 
  #     | Purchases | dashboard purchases page          | 
  #     | Selling   | dashboard sales page              | 
  #     | Orders    | dashboard orders page             | 
  #     | Inventory | dashboard quotes page             | 
  #     | Products  | dashboard products page           | 
  #     | Stores    | dashboard seller_inventories page | 
  #     | Feedback  | dashboard reviews page            | 
