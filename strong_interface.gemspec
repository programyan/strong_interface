# frozen_string_literal: true

require_relative 'lib/strong_interface/version'

Gem::Specification.new do |spec|
  spec.name          = 'strong_interface'
  spec.version       = StrongInterface::VERSION
  spec.authors       = ['Andrew Ageev']
  spec.email         = ['ageev86@gmail.com']

  spec.summary       = 'Simple implementation of an interface pattern for Ruby'
  spec.description   = 'Simple implementation of an interface pattern for Ruby'
  spec.homepage      = 'https://github.com/programyan/strong_interface'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.1')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/programyan/strong_interface'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]
end
