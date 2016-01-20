require 'kolekti/persistence_strategy'

class TestPersistenceStrategy < Kolekti::PersistenceStrategy
  def create_tree_metric_result(metric_configuration, module_name, value, granularity)
    puts "Create tree metric result: #{module_name} #{metric_configuration} #{value} #{granularity}"
  end

  def create_hotspot_metric_result(metric_configuration, module_name, line, message)
    puts "Create hotspot metric result: #{module_name} #{metric_configuration} #{line} #{message}"
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
