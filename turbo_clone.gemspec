require_relative "lib/turbo_clone/version"

Gem::Specification.new do |spec|
  spec.name        = "turbo_clone"
  spec.version     = TurboClone::VERSION
  spec.authors     = ["pierandreadelise"]
  spec.email       = ["misterious_email@gmail.com"]
  spec.summary     = "TurboClone."
  spec.license     = "MIT"

  # Spec files that get installed with the gem
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.0"
end
