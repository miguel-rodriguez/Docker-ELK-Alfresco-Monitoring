# coding: utf-8
lib = File.expand_path('./lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "jrmonitor"
  spec.version       = "0.4.2"
  spec.authors       = ["Elastic"]
  spec.email         = ["info@elastic.co"]

  spec.summary       = %q{JVM Platform MXBeans wrapper used for monitoring.}
  spec.description   = %q{This gems allows you to access in a Ruby friendly way the internal JVM monitoring tools for things like System, Threads and Memory information}
  spec.homepage      = "http://www.elastic.co/guide/en/logstash/current/index.html"
  spec.license       = "Apache License (2.0)"

  spec.files         = Dir.glob(["jrmonitor.gemspec", "lib/**/*.rb", "spec/**/*.rb", "jruby-ext/target/classes/**/*.class"])
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "jruby-ext"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "pry", "~> 0.10.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
