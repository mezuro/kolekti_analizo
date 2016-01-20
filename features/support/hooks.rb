require 'fileutils'

Before('@clear_test_dir') do
  FileUtils.rm_rf(@repository_path) if File.exists?(@repository_path)
end

After('@unregister_collectors') do
  Kolekti.collectors.each { |collector| Kolekti.unregister_collector(collector) }
end
