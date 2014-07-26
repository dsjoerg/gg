# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gg/version"

Gem::Specification.new do |s|
  s.name        = "gg"
  s.version     = GG::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Marian Rudzynski"]
  s.email       = ["mr@impaled.org"]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""

  s.add_dependency('rest-client')
  s.add_dependency('hashie')
  s.add_dependency('yajl-ruby')

  # Because I just don't want to live without some of it..
  s.add_dependency('activesupport')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
