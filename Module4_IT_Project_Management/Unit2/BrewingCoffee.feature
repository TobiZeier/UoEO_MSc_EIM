Feature: Brewing Coffee

Scenario: Successfully brew a cup of coffee

  Given the coffee machine is plugged in and turned on,
    And the water tank is filled,
    And coffee grounds are added to the filter,
   When I select the "Brew" option,
   Then the machine should brew a cup of coffee.
