Feature: Collect Analizo metrics
  In order to analyze C, C++ or JAVA source codes
  As a Kolekti user
  I should be able to collect metrics using Analizo

  @unregister_collectors @clear_repository_dir
  Scenario: Running, parsing and collecting results
    Given Analizo is registered on Kolekti
    And a persistence strategy is defined
    And I have a set of wanted metrics for Analizo
    And the "https://github.com/rafamanzo/runge-kutta-vtk.git" repository is cloned
    When I request Kolekti to collect the wanted metrics
    Then there should be tree metric results to be saved
    And there should be tree metric results for all the wanted metrics
