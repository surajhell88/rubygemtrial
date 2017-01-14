# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rubygemtrial/version'

Gem::Specification.new do |spec|
  spec.name          = "rubygemtrial"
  spec.version       = Rubygemtrial::VERSION
  spec.authors       = ["Suraj Jadhav"]
  spec.email         = ["suraj*****@gmail.com"]

  spec.summary       = %q{Try developing ruby gem}
  spec.description   = %q{Gem that does magic}
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = Dir["{bin,lib}/**/*", "LICENSE", "README.md"]  
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  
  spec.add_dependency 'thor'

  spec.add_runtime_dependency "netrc"
  spec.add_runtime_dependency "octokit", "~> 4.0"
  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "git"
  spec.add_runtime_dependency "faraday", "~> 0.9"
end
