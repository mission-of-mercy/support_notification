require_relative 'lib/support_notification'
require 'resque'
# Setup Resque
Resque.redis = "#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}"

require 'resque/tasks'

task :console do
  exec "irb -I lib -r support_notification"
end
