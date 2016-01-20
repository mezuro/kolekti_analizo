require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => [:spec, :acceptance]

desc 'Runs the acceptance tests'
task :acceptance, [:feature] do |t, args|
  if args.feature.nil?
    acceptance_tests_command = "bundle exec cucumber"
  else
    acceptance_tests_command = "bundle exec cucumber #{args.feature} features/step_definitions/ features/support/"
  end

  puts "Running the acceptance tests with \"#{acceptance_tests_command}\"\n\n"
  system acceptance_tests_command
end
