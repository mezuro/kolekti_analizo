require 'kalibro_client'

FactoryGirl.define do
  factory :metric_configuration, class: KalibroClient::Entities::Configurations::MetricConfiguration do
    metric { FactoryGirl.build(:metric) }
    weight 1
    aggregation_form 'mean'
    reading_group_id 1
    kalibro_configuration_id 1

    trait :with_id do
      sequence(:id, 1)
    end
  end

  factory :other_metric_configuration, parent: :metric_configuration do
    metric { FactoryGirl.build(:metric, code: 'other') }
  end

end
