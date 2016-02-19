require 'kolekti/persistence_strategy'
require 'kolekti/memory_persistence_strategy'

FactoryGirl.define { factory :persistence_strategy, class: Kolekti::MemoryPersistenceStrategy }
