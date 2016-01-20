module Kolekti
  module Analizo
    class Parser
      def initialize(wanted_metric_configurations, persistence_strategy)
        @wanted_metric_configurations = wanted_metric_configurations
        @persistence_strategy = persistence_strategy
      end

      def parse_all(output)
        YAML.load_documents(output).each do |hash|
          parse(hash)
        end
      end

      private

      def parse_file_name(file_name)
        without_extension = file_name.rpartition('.').first
        without_extension.gsub('.', '_').gsub('/', '.')
      end

      def parse_class_name(analizo_module_name)
        analizo_module_name.split('::').join('.')
      end

      def module_name(file_name, analizo_module_name)
        "#{parse_file_name(file_name)}.#{parse_class_name(analizo_module_name)}"
      end

      def parse(result_map)
        result_map.each do |code, value|
          metric_configuration = @wanted_metric_configurations[code]
          next if metric_configuration.nil?

          if result_map['_filename'].nil?
            @persistence_strategy.create_tree_metric_result(
              metric_configuration, "ROOT", value, KalibroClient::Entities::Miscellaneous::Granularity::SOFTWARE)
          else
            name = module_name(result_map['_filename'].last, result_map['_module'])
            @persistence_strategy.create_tree_metric_result(
              metric_configuration, name, value, KalibroClient::Entities::Miscellaneous::Granularity::CLASS)
          end
        end
      end
    end
  end
end
