# -*- encoding: utf-8 -*-
# stub: virtus 1.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "virtus"
  s.version = "1.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Piotr Solnica"]
  s.date = "2015-03-18"
  s.description = "Attributes on Steroids for Plain Old Ruby Objects"
  s.email = ["piotr.solnica@gmail.com"]
  s.extra_rdoc_files = ["LICENSE", "README.md", "TODO.md"]
  s.files = ["LICENSE", "README.md", "TODO.md"]
  s.homepage = "https://github.com/solnic/virtus"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.9"
  s.summary = "Attributes on Steroids for Plain Old Ruby Objects"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<descendants_tracker>, [">= 0.0.3", "~> 0.0"])
      s.add_runtime_dependency(%q<equalizer>, [">= 0.0.9", "~> 0.0"])
      s.add_runtime_dependency(%q<coercible>, ["~> 1.0"])
      s.add_runtime_dependency(%q<axiom-types>, ["~> 0.1"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<descendants_tracker>, [">= 0.0.3", "~> 0.0"])
      s.add_dependency(%q<equalizer>, [">= 0.0.9", "~> 0.0"])
      s.add_dependency(%q<coercible>, ["~> 1.0"])
      s.add_dependency(%q<axiom-types>, ["~> 0.1"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<descendants_tracker>, [">= 0.0.3", "~> 0.0"])
    s.add_dependency(%q<equalizer>, [">= 0.0.9", "~> 0.0"])
    s.add_dependency(%q<coercible>, ["~> 1.0"])
    s.add_dependency(%q<axiom-types>, ["~> 0.1"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
