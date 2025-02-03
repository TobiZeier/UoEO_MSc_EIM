Feature: Adjusting Coffee Strength

Scenario: Brew a stronger cup of coffee

  Given the coffee machine is ready to brew,
   When I select the "Strong" option,
   Then the machine should brew a stronger cup of coffee.