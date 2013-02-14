# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "siriproxy-videro"
  s.version     = "0.0.1" 
  s.authors     = ["Dominik Louven and Philipp Kirchner"]
  s.email       = ["p.kirchner@videro.com"]
  s.homepage    = "https://github.com/pkirchner/SiriProxy-VIDERO"
  s.summary     = %q{A SiriProxy plugin to control your VIDERO.}
  s.description = %q{Simple control of your VIDERO currently on German only. Feel free to extend!}

  s.rubyforge_project = "siriproxy-videro"

  s.files         = `git ls-files 2> /dev/null`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/* 2> /dev/null`.split("\n")
  s.executables   = `git ls-files -- bin/* 2> /dev/null`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
