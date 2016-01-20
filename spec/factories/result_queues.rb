FactoryGirl.define do
  factory :result_queue, class: Array do
    initialize_with { [{ metric: 2 }, { metric: 3 }] }
  end
  factory :empty_result_queue, class: Array do
    initialize_with { [] }
  end
end
