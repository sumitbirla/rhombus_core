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

  s.add_dependency "rails", "~> 4.2.6"
  s.add_dependency "bcrypt"
  s.add_dependency "simple_form"
  s.add_dependency "useragent"
  s.add_dependency "country_select"
  s.add_dependency "countries"
  s.add_dependency "will_paginate"
  s.add_dependency "bootstrap-will_paginate"
  s.add_dependency "cupsffi"
end
