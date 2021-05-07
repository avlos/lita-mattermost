Gem::Specification.new do |spec|
  spec.name          = "lita-mattermost"
  spec.version       = "0.1.0"
  spec.authors       = ["Maria Karamina"]
  spec.email         = ["maria.karamina@avlos.ai"]
  spec.description   = "Lita adapter for Mattermost"
  spec.summary       = "Lita adapter for Mattermost"
  spec.homepage      = "https://git.avlos.io/infrastructure/pandora/lita-mattermost"
  # spec.license       = "Add a license"
  spec.metadata      = { "lita_plugin_type" => "adapter" }

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "lita", ">= 4.8"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "pry-byebug"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec", ">= 3.0.0"
end
