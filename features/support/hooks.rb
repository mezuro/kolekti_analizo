require 'fileutils'

After('@clear_repository_dir') do
  FileUtils.rm_rf(@repository_path) if File.exists?(@repository_path)
  @repository_path = nil
end

After('@unregister_collectors') do
  Kolekti.collectors.each { |collector| Kolekti.deregister_collector(collector.class) }
end
