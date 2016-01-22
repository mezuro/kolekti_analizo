require 'tmpdir'
require 'fileutils'

require 'spec_helper'
require 'kalibro_client'
require 'kolekti'

describe Kolekti::Analizo::Collector do
  context 'without a simulated metrics list' do
    describe 'initialize' do
      context 'when analizo failed' do
        before :each do
          described_class.any_instance.expects(:`).with('analizo metrics --list').returns("")
          $?.expects(:success?).returns(false)
          $?.expects(:exitstatus).returns(1)
        end

        it 'is expected to raise Kolekti::CollectorError with the correct exit status' do
          expect { described_class.new }.to raise_error(Kolekti::CollectorError,  "Analizo failed with exit status: 1")
        end
      end

      context 'when analizo succeeded' do
        let(:metric_list) { FactoryGirl.build(:analizo_metric_collector_list).raw }
        let(:acc_metric) { FactoryGirl.build(:acc_metric) }
        let(:tac_metric) { FactoryGirl.build(:total_abstract_classes_metric) }
        let(:supported_metrics) { { acc_metric.code => acc_metric, tac_metric.code => tac_metric } }

        before :each do
          described_class.any_instance.expects(:`).with('analizo metrics --list').returns(metric_list)
          $?.expects(:success?).returns(true)
        end

        it 'is expected to raise Kolekti::CollectorError' do
          instance = described_class.new
          expect(instance.supported_metrics).to eq(supported_metrics)
        end
      end
    end
  end

  context 'with a simulated metrics list' do
    before :each do
      described_class.any_instance.expects(:load_analizo_supported_metrics).returns({})
    end

    describe 'available?' do
      context 'when the collector is available' do
        it 'is expected to return true' do
          subject.expects(:system).with(regexp_matches(/^analizo\b/), anything).returns(true)
          expect(subject.available?).to eq true
        end
      end

      context 'when the collector is not available' do
        it 'is expected to return false' do
          subject.expects(:system).with(regexp_matches(/^analizo\b/), anything).returns(nil)
          expect(subject.available?).to eq false
        end
      end
    end

    describe 'default_value_from' do
      context 'with a valid metric configuration' do
        let(:metric) { FactoryGirl.build(:analizo_metric) }
        let(:metric_configuration) { FactoryGirl.build(:metric_configuration, metric: metric) }
        it 'is expected to return 0.0' do
          expect(subject.default_value_from(metric_configuration)).to eq(0.0)
        end
      end

      context 'with an invalid metric configuration' do
        let(:metric) { FactoryGirl.build(:native_metric) }
        let(:metric_configuration) { FactoryGirl.build(:metric_configuration, metric: metric) }
        it 'is expected to raise an ArgumentError exception' do
          expect { subject.default_value_from(metric_configuration) }.to raise_error(ArgumentError, "Metric configuration does not belong to Analizo")
        end
      end
    end

    describe 'collect_metrics' do
      let(:code_directory) { '/tmp/test' }
      let(:wanted_metric_configurations) { mock }
      let(:persistence_strategy) { mock }
      let(:analizo_metric_collector_list) { FactoryGirl.build(:analizo_metric_collector_list).raw_result }

      before :each do
        described_class.any_instance.expects(:`).with("analizo metrics #{code_directory}").returns(analizo_metric_collector_list)
      end

      context 'when running succeeded' do
        before :each do
          Kolekti::Analizo::Parser.any_instance.expects(:parse_all).with(analizo_metric_collector_list)
          $?.expects(:success?).returns(true)
        end

        it 'is expected to run succesfully' do
          subject.collect_metrics(code_directory, wanted_metric_configurations, persistence_strategy)
        end
      end

      context 'when running failed' do
        before :each do
          $?.expects(:success?).returns(false)
          $?.expects(:exitstatus).returns(1)
        end

        it 'is expected to raise Kolekti::CollectorError with the correct exit status' do
          expect { subject.collect_metrics(code_directory, wanted_metric_configurations, persistence_strategy) }.to raise_error(
            Kolekti::CollectorError, "Analizo failed with exit status: 1")
        end
      end
    end
  end
end
