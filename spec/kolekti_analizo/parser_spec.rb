require 'spec_helper'
require 'kalibro_client'

describe Kolekti::Analizo::Parser do
  describe 'methods' do
    describe 'parse_all' do
      let(:acc_metric) { FactoryGirl.build(:acc_metric) }
      let(:tac_metric) { FactoryGirl.build(:total_abstract_classes_metric) }

      let(:acc_metric_configuration) { FactoryGirl.build(:metric_configuration, metric: acc_metric) }
      let(:tac_metric_configuration) { FactoryGirl.build(:metric_configuration, metric: tac_metric) }

      let(:analizo_metric_collector_list) { FactoryGirl.build(:analizo_metric_collector_list) }
      let(:wanted_metrics) { { acc_metric.code => acc_metric_configuration, tac_metric.code => tac_metric_configuration } }
      let(:persistence_strategy) { mock('persistence_strategy').responds_like_instance_of(Kolekti::PersistenceStrategy) }

      subject { Kolekti::Analizo::Parser.new(wanted_metrics, persistence_strategy) }

      before :each do
        YAML.expects(:load_documents).with(analizo_metric_collector_list.raw_result).returns(analizo_metric_collector_list.parsed_result)
        persistence_strategy.expects(:create_tree_metric_result).with(tac_metric_configuration, 'ROOT', 10.0, KalibroClient::Entities::Miscellaneous::Granularity::SOFTWARE)
        persistence_strategy.expects(:create_tree_metric_result).with(acc_metric_configuration, 'Class.My.Software.Module', 0.0, KalibroClient::Entities::Miscellaneous::Granularity::CLASS)
      end

      it 'is expected to parse the raw results into ModuleResults and TreeMetricResults' do
        subject.parse_all(analizo_metric_collector_list.raw_result)
      end
    end
  end
end
