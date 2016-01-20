require 'tmpdir'

Given(/^Analizo is registered on Kolekti$/) do
  Kolekti.register_collector(Kolekti::Analizo::Collector.new)
end

Given(/^a persistence strategy is defined$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^I have a set of wanted metrics for Analizo$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Given(/^the "([^"]*)" repository is cloned$/) do |arg1|
  pending # Write code here that turns the phrase above into concrete actions
end

When(/^I request Kolekti to collect the wanted metrics$/) do
  pending # Write code here that turns the phrase above into concrete actions
end

Then(/^there should be native metric results to be saved$/) do
  pending # Write code here that turns the phrase above into concrete actions
end
