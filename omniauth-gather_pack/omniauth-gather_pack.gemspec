require_relative "lib/omniauth-gather_pack/version"

Gem::Specification.new do |gem|
  gem.name = "omniauth-gather_pack"
  gem.version = OmniAuth::GatherPack::VERSION
  gem.authors = [ "Brad" ]
  gem.email = [ "brad@example.com" ]

  gem.summary = "OmniAuth strategy for GatherPack"
  gem.description = "Authenticate against any GatherPack instance via its Doorkeeper-powered OAuth2 provider."
  gem.homepage = "https://github.com/your/omniauth-gather_pack"
  gem.license = "MIT"

  gem.required_ruby_version = ">= 3.1"

  gem.files = Dir["lib/**/*", "LICENSE.txt", "README.md"]
  gem.require_paths = [ "lib" ]

  gem.add_dependency "omniauth", "~> 2.0"
  gem.add_dependency "omniauth-oauth2", "~> 1.8"

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", "~> 3.0"
  gem.add_development_dependency "rack-test"
  gem.add_development_dependency "webmock"
end
