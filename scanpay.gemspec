Gem::Specification.new do |s|
  s.name        = 'scanpay'
  s.version     = '1.0.0'
  s.license     = 'MIT'
  s.summary     = "Ruby bindings for the Scanpay API"
  s.description = "Accept payments with the Scanpay payment gateway. See https://scanpay.dk for more details."
  s.author      = 'Scanpay'
  s.email       = 'contact@scanpay.dk'
  s.homepage    = 'https://github.com/scanpaydk/ruby-scanpay'
  s.files       = ["lib/scanpay.rb"]
  s.require_paths = ['lib']
  s.add_runtime_dependency('httpclient', '>= 2.6')
  s.required_ruby_version = '>= 2.0.0'
end
