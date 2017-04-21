# -*- encoding: utf-8 -*-
# stub: ice_nine 0.11.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ice_nine"
  s.version = "0.11.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Kubb"]
  s.date = "2014-12-03"
  s.description = "Deep Freeze Ruby Objects"
  s.email = ["dan.kubb@gmail.com"]
  s.extra_rdoc_files = ["LICENSE", "README.md", "TODO"]
  s.files = ["LICENSE", "README.md", "TODO"]
  s.homepage = "https://github.com/dkubb/ice_nine"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.9"
  s.summary = "Deep Freeze Ruby Objects"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 1.6.1", "~> 1.6"])
    else
      s.add_dependency(%q<bundler>, [">= 1.6.1", "~> 1.6"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 1.6.1", "~> 1.6"])
  end
end
