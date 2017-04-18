# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bubbles/version'

Gem::Specification.new do |spec|
  spec.name          = "bubbles"
  spec.version       = Bubbles::VERSION
  spec.authors       = ["Tomas Valent"]
  spec.licenses      = ['MIT']
  spec.email         = ["equivalent@eq8.eu"]

  spec.summary       = %q{Lightweight daemon file uploader to cloud}
  spec.description   = %q{Daemonized file uploader that watch a folder and uploads any files files to AWS S3. Designed for Raspberry pi zero}
  spec.homepage      = "https://github.com/equivalent/bubbles"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "aws-sdk", "~> 2"
  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
