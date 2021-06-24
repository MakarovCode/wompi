lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "wompi/version"

Gem::Specification.new do |spec|
  spec.name          = "wompi"
  spec.version       = Wompi::VERSION
  spec.authors       = ["MakarovCode"]
  spec.email         = ["simoncorreaocampo@gmail.com"]

  spec.summary       = "Gem to use the Wompi API simple"
  spec.description = "Ruby gem to use the Wompi API simple"
  spec.homepage      = "https://github.com/MakarovCode/WompiApi"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
end
