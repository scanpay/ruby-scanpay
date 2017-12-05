Gem::Specification.new do |s|
  s.name        = 'scanpay'
  s.version     = '1.0.0'
  s.summary     = "Ruby bindings for the Scanpay API"
  s.description = "Accept payments with the Scanpay payment gateway. See https://scanpay.dk for more details."
  s.author      = 'Scanpay'
  s.email       = 'contact@scanpay.dk'
  s.homepage    = 'https://github.com/scanpaydk/ruby-scanpay'
  s.license     = 'MIT'
  s.add_runtime_dependency('httpclient', '~> 2.8')
  s.files       = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- tests/*`.split("\n")
  s.require_paths = ['lib']
end
