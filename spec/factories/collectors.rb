require 'kolekti/collector'

FactoryGirl.define do
  factory :collector, class: Kolekti::Collector do
    name 'collector'
    description ''
    supported_metrics { metric = FactoryGirl.build(:metric); { metric.code => metric } }

    initialize_with { new(name, description, supported_metrics) }
  end
end
