
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cloud_text/version"

Gem::Specification.new do |spec|
  spec.name          = "cloud_text"
  spec.version       = CloudText::VERSION
  spec.authors       = ["recepinanc"]
  spec.email         = ["recepinancc@gmail.com"]

  spec.summary       = "Cleans the given text for the given language."
  spec.description   = "This gem removes punctuation and digits(optional), filters stopwords for the chosen language ('tr', 'en' or 'fr'), does stemming on the words and outputs an array of words with their frequencies."
  spec.homepage      = "https://github.com/twentify/cloud_text"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_runtime_dependency 'unicode_utils', '~> 1.4'
  spec.add_runtime_dependency 'stopwords-filter', '~> 0.4.1'
  spec.add_runtime_dependency 'ruby-stemmer', '~> 0.9.6'
end
