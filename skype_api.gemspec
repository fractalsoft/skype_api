# -*- encoding: utf-8 -*-
require File.expand_path('../lib/skype_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Aleksander Malaszkiewicz"]
  gem.email         = ["info@fractalsoft.org"]
  gem.description   = %q{Skype API}
  gem.summary       = %q{Skype API}
  gem.homepage      = "https://github.com/fractalsoft/skype_api"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "skype_api"
  gem.require_paths = ["lib"]
  gem.version       = SkypeApi::VERSION

  gem.add_development_dependency "rspec"
  gem.add_dependency "ruby-dbus"
end
