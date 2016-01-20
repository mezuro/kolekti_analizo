require 'tmpdir'
require 'fileutils'

require 'spec_helper'
require 'kalibro_client'
require 'kolekti'

describe Kolekti::Analizo::Collector do
  subject { described_class.new }

  describe 'default_value_from' do
    context 'with a valid metric configuration' do
      let(:metric) { FactoryGirl.build(:analizo_metric) }
      let(:metric_configuration) { FactoryGirl.build(:metric_configuration, metric: metric) }
      it 'is expected to return 0.0' do
        expect(subject.default_value_from(metric_configuration)).to eq(0.0)
      end
    end

    context 'with an invalid metric configuration' do
      let(:metric) { FactoryGirl.build(:flog_metric) }
      let(:metric_configuration) { FactoryGirl.build(:metric_configuration, metric: metric) }
      it 'is expected to raise an ArgumentError exception' do
        expect { subject.default_value_from(metric_configuration) }.to raise_error(ArgumentError)
      end
    end
  end

  describe 'run_wanted_metrics' do
    let(:metric_configurations) { [FactoryGirl.build(:metric_configuration), FactoryGirl.build(:metric_configuration, metric: FactoryGirl.build(:analizo_metric))] }
    let(:strategy) { FactoryGirl.build(:persistence_strategy) }

    context 'with a C++ repository' do
      let(:repository_path) { Dir::mktmpdir }
      let(:runner) { Kolekti::Runner.new(repository_path, metric_configurations, strategy) }

      before :each do
        Kolekti.register_collector(subject)
      end

      after :each do
        Kolekti.unregister_collector(subject)
      end

      it 'is expected to run the wanted metrics' do
        begin
          # FIXME: Find a beter way to clone and clean the repository to be analized
          unless `git clone -q 'https://github.com/rafamanzo/runge-kutta-vtk.git' '#{repository_path}'`
            raise StandardError.new('git clone failed')
          end
          runner.run_wanted_metrics
        ensure
          FileUtils.rm_rf(repository_path)
        end
      end
    end
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
end
