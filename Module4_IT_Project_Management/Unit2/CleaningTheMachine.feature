Feature: Cleaning the Machine

Scenario: Perform a cleaning cycle
  Given the coffee machine is turned on,
    And the water tank is filled with cleaning solution,
   When I select the "Clean" option,
   Then the machine should run a cleaning cycle.