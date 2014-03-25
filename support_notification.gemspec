Gem::Specification.new do |s|
  s.name        = "support_notification"
  s.version     = File.read('VERSION').strip
  s.authors     = ["Jordan Byron"]
  s.email       = ["jordan.byron@gmail.com"]
  s.homepage    = "https://github.com/mission-of-mercy/support_notification"
  s.summary     = "Send SMS and Prowl notifications for MOMMA"
  s.description = "Send SMS and Prowl notifications for Mission of Mercy Management Application"
  s.require_path = "lib"
  s.files = Dir["{lib}/**/*"] +
    %w{Rakefile README.md LICENSE}

  s.add_dependency "resque", "~> 1.25.2"
  s.add_dependency "twilio", "~> 3.1.1"
  s.add_dependency "prowl",  "~> 0.1.3"

  s.add_development_dependency "bundler"
end
