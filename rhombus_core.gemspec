$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rhombus_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rhombus_core"
  s.version     = RhombusCore::VERSION
  s.authors     = ["Sumit Birla"]
  s.email       = ["sbirla@tampahost.net"]
  s.homepage    = "http://github.com/sumitbirla/rhombus_core"
  s.summary     = "Base files for Rhombus based web apps"
  s.description = "Rhombus is a rails framework to quickly spin up website with different sets of functionality."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "7.1.3.4"
  s.add_dependency "cbor", "0.5.9.8"
  s.add_dependency "cose", "1.3.0"
  s.add_dependency "bcrypt", "3.1.20"
  s.add_dependency "simple_form", "5.3.1"
  s.add_dependency "useragent", "0.16.10"
  s.add_dependency "country_select", "9.0.0"
  s.add_dependency "countries", "6.0.1"
  s.add_dependency "will_paginate", "3.3.1"
  s.add_dependency "bootstrap-will_paginate", '1.0.0'
  s.add_dependency "cupsffi", "0.1.9"
  s.add_dependency "acts-as-taggable-on", "10.0.0"
end
