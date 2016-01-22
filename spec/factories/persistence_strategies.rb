require 'kolekti/persistence_strategy'

class TestPersistenceStrategy < Kolekti::PersistenceStrategy
  attr_reader :tree_metric_results, :hotspot_metric_results

  def initialize
    @tree_metric_results = []
    @hotspot_metric_results = []
  end

  def create_tree_metric_result(metric_configuration, module_name, value, granularity)
    @tree_metric_results << {
      metric_configuration: metric_configuration,
      module_name: module_name,
      value: value,
      granularity: granularity
    }
  end

  def create_hotspot_metric_result(metric_configuration, module_name, line, message)
    @hotspot_metric_results << {
      metric_configuration: metric_configuration,
      module_name: module_name,
      line: line,
      message: message
    }
  end

  def create_related_hotspot_metric_results(metric_configuration, results)
    puts "Started related hotspots"

    results.each do |result|
      create_hotspot_metric_result(metric_configuration, result['module_name'], result['line'], result['message'])
    end

    puts "End related hotspots"
  end
end

FactoryGirl.define { factory :persistence_strategy, class: TestPersistenceStrategy }
