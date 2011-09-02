# Feature: Describe how auction work

#   Scenario: Add product to auction
#     Given I am seller
#     Then I create new product with name as "my awesome product" and price "20$"
#     Then I go to the dashboard products page
#     And I click "lot at auction"
#     And I should be on the new auction page for "my awesome product"
#     And I fill in "lot min price" with "10$"
#     And I fill in "end auction" with "05.09.2011 9:00 PM"
#     And I press "start auction"
#     And I should have a product variant with auction status

#   Scenario: dashboard lot page
#     Given I am seller
#     And I have some auction lot
#     Then I go to the dashboard quotes
#     And I should see my quoutes
#     And quoutes that lot should be market
#     And I click by my auction lot

#   Scenario: Buy a lot from auction
#     Given I am signed user
#     And I go to the auction page
#     And I should see all auction lot
#     And I should see search bar
#     And I should see select by category
#     And I should see by each lot how many claims
#     And I should see end time of each auction
#     And I should see each lot name
#     And I should see each lot min price
#     And I should see each lot seller
#     And I should see each log seller rating
#     And I click "trade" link by "my awesome product"
#     And I should be on the auction product "my awesome product" page
#     And I should see all claims by this lot with price
#     And I should see last claims for this log
#     And I should see "Buy now without auction by 20$"
#     And I click create claims link
#     And I fill in "you bet" with "14"
#     And I should not fill "you bet" less than last claim price
#     And I click create claim
#     And I see "You confirm your bid to $ 14"
#     And I click "Agree"
#     Then auction time is end
#     And my claim last
#     And I should get notification by email
#     And I should see in my cart this lot with price "$14"
#     And I checkout lot

