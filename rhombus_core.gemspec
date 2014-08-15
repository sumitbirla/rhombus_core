$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rhombus_core/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rhombus_core"
  s.version     = RhombusCore::VERSION
  s.authors     = ["Sumit Birla"]
  s.email       = ["sbirla@tampahost.net"]
  s.homepage    = "http://sumitbirla.com"
  s.summary     = "Base files for Rhombus based web apps."
  s.description = "Description of RhombusCore."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.4"
  s.add_dependency "bcrypt"
  s.add_dependency "simple_form", "~> 3.1.0.rc2"
  s.add_dependency "omniauth-facebook"
  s.add_dependency "useragent"
  s.add_dependency "country_select"
  s.add_dependency "cancan"
  s.add_dependency "will_paginate", "~> 3.0"
  s.add_dependency "bootstrap-will_paginate"
end
