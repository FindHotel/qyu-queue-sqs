
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "qyu/queue/sqs/version"

Gem::Specification.new do |spec|
  spec.name          = "qyu-queue-sqs"
  spec.version       = Qyu::Queue::SQS::VERSION
  spec.authors       = ["Andrew Kumanyaev"]
  spec.email         = ["me@zzet.org"]

  spec.summary       = %q{Amazon SQS message queue for Qyu https://rubygems.org/gems/qyu}
  spec.description   = %q{Amazon SQS message queue for Qyu https://rubygems.org/gems/qyu}
  spec.homepage      = "https://github.com/FindHotel/qyu-queue-sqs"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "rspec", "~> 3.5"
  spec.add_development_dependency 'simplecov'

  spec.add_runtime_dependency 'aws-sdk-sqs', '~> 1.3'
end
