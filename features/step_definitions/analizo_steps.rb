require 'tmpdir'

Given(/^Analizo is registered on Kolekti$/) do
  Kolekti.register_collector(Kolekti::Analizo::Collector)
end

Given(/^a persistence strategy is defined$/) do
  @persistence_strategy = FactoryGirl.build(:persistence_strategy)
end

Given(/^I have a set of wanted metrics for Analizo$/) do
  acc_metric = FactoryGirl.build(:acc_metric)
  tac_metric = FactoryGirl.build(:total_abstract_classes_metric)
  @wanted_metric_configurations = [
    FactoryGirl.build(:metric_configuration, metric: acc_metric),
    FactoryGirl.build(:metric_configuration, metric: tac_metric)
  ]
end

Given(/^the "([^"]+)" repository is cloned$/) do |repository_url|
  @repository_path = Dir::mktmpdir

  expect(system("git clone -q '#{repository_url}' '#{@repository_path}'", [:out, :err] => '/dev/null')).to be_truthy
end

When(/^I request Kolekti to collect the wanted metrics$/) do
  @runner = Kolekti::Runner.new(@repository_path, @wanted_metric_configurations, @persistence_strategy)
  @runner.run_wanted_metrics
end

Then(/^there should be tree metric results to be saved$/) do
  expect(@persistence_strategy.tree_metric_results).to_not be_empty
end

Then(/^there should be tree metric results for all the wanted metrics$/) do
  metric_configurations = @persistence_strategy.tree_metric_results.map do |tree_metric_result|
    tree_metric_result[:metric_configuration]
  end
  metric_configurations.uniq!

  @wanted_metric_configurations.each do |wanted_metric_configuration|
    expect(metric_configurations).to include(wanted_metric_configuration)
  end
end
