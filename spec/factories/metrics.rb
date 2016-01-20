require 'kalibro_client'

FactoryGirl.define  do
  factory :metric, class: KalibroClient::Entities::Miscellaneous::Metric do
    name "Total Lines of Code"
    code "total_loc"
    type 'TestMetricSnapshot'
    scope 'SOFTWARE'

    initialize_with { new(type, name, code, scope) }
  end

  trait :native do
    type 'NativeMetricSnapshot'
    languages [:C]
  end

  factory :native_metric, class: KalibroClient::Entities::Miscellaneous::NativeMetric do
    native

    name "Native Metric"
    code "NM"
    description "A native metric"
    metric_collector_name 'NativeTestCollector'
    scope 'METHOD'

    initialize_with { new(name, code, scope, languages, metric_collector_name) }
  end

  factory :analizo_metric, parent: :native_metric do
    languages [:C, :CPP, :JAVA]
    metric_collector_name "Analizo"
    scope 'CLASS'
    name 'Afferent Connections per Class (used to calculate COF - Coupling Factor)'
    code 'acc'
    description ''
  end

  factory :acc_metric, parent: :analizo_metric do
    name "Afferent Connections per Class (used to calculate COF - Coupling Factor)"
    code "acc"
    scope :CLASS
  end

  factory :total_abstract_classes_metric, parent: :analizo_metric do
    name "Total Abstract Classes"
    code "total_abstract_classes"
    scope :SOFTWARE
  end
end
