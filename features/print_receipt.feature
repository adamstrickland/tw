Feature: Print Receipts
  As a Thoughtworker, 
  In order to assess Adam Strickland's ability
  I want to run his program using some supplied basket inputs

Scenario: Basket Number 1
  Given the basket:
    | input |
    | 1 book at 12.49 |
    | 1 music CD at 14.99 |
    | 1 chocolate bar at 0.85 |
  When I print the receipt
  Then I should see the lines:
    | output |
    | 1 book: 12.49 |
    | 1 music CD: 16.49 |
    | 1 chocolate bar: 0.85 |
  And I should see the sales taxes of 1.50
  And I should see the total of 29.83

Scenario: Basket Number 2
  Given the basket:
    | input |
    | 1 imported box of chocolates at 10.00 |
    | 1 imported bottle of perfume at 47.50 |
  When I print the receipt
  Then I should see the lines:
    | output |
    | 1 imported box of chocolates: 10.50 |
    | 1 imported bottle of perfume: 54.65 |
  And I should see the sales taxes of 7.65
  And I should see the total of 65.15
  
  Scenario: Basket Number 3
    Given the basket:
      | input |
      | 1 imported bottle of perfume at 27.99 |
      | 1 bottle of perfume at 18.99 |
      | 1 packet of headache pills at 9.75 |
      | box of imported chocolates at 11.25 |
    When I print the receipt
    Then I should see the lines:
      | output |
      | 1 imported bottle of perfume: 32.19 |
      | 1 bottle of perfume: 20.89 |
      | 1 packet of headache pills: 9.75 |
      | 1 imported box of chocolates: 11.85 |
    And I should see the sales taxes of 6.70
    And I should see the total of 74.68