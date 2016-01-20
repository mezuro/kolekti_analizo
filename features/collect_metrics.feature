Feature: Collect Analizo metrics
  In order to analyze C, C++ or JAVA source codes
  As a Kolekti user
  I should be able to collect metrics using Analizo

  @unregister_collectors
  Scenario: Running, parsing and collecting results
    Given Analizo is registered on Kolekti
    And a persistence strategy is defined
    And I have a set of wanted metrics for Analizo
    And the "runge-kutta-vtk" repository is cloned
    When I request Kolekti to collect the wanted metrics
    Then there should be native metric results to be saved
