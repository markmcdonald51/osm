log_level :info
file_cache_path "#{::File.dirname(::File.expand_path(__FILE__))}/cache"
file_backup_path "#{::File.dirname(::File.expand_path(__FILE__))}/cache/backup"
cookbook_path [ "#{::File.dirname(::File.expand_path(__FILE__))}/cookbooks" ]