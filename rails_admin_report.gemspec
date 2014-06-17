$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_report/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_admin_report"
  s.version     = RailsAdminReport::VERSION
  s.authors     = ["Clairton Rodrigo Heinzen"]
  s.email       = ["clairton.rodrigo@gmail.com"]
  s.homepage    = "http://github.com/clairton"
  s.summary     = "Report Action for RailsAdmin."
  s.description = "Report Action to generate RailsAdmin."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", ">= 4.1.1"
  s.add_dependency "rails_admin", ">= 0.6.2"
end
