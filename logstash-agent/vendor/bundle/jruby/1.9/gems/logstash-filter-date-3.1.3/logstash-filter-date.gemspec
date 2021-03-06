Gem::Specification.new do |s|

  s.name            = 'logstash-filter-date'
  s.version         = '3.1.3'
  s.licenses        = ['Apache License (2.0)']
  s.summary         = "The date filter is used for parsing dates from fields, and then using that date or timestamp as the logstash timestamp for the event."
  s.description     = "This gem is a Logstash plugin required to be installed on top of the Logstash core pipeline using $LS_HOME/bin/logstash-plugin install gemname. This gem is not a stand-alone program"
  s.authors         = ["Elastic"]
  s.email           = 'info@elastic.co'
  s.homepage        = "http://www.elastic.co/guide/en/logstash/current/index.html"
  s.require_paths = ["lib", "vendor/jar-dependencies"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','CONTRIBUTORS','Gemfile','LICENSE','NOTICE.TXT', "vendor/jar-dependencies/**/*.jar"]

  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = { "logstash_plugin" => "true", "logstash_group" => "filter" }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", ">= 1.60", "<= 2.99"
  s.add_development_dependency 'logstash-input-generator'
  s.add_development_dependency 'logstash-codec-json'
  s.add_development_dependency 'logstash-output-null'
  s.add_development_dependency 'logstash-devutils'
  s.add_development_dependency 'benchmark-ips'
end

