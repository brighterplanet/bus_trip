# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bus_trip/version"

Gem::Specification.new do |s|
  s.name = %q{bus_trip}
  s.version = BrighterPlanet::BusTrip::VERSION

  s.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", "Derek Kastner"]
  s.date = %q{2011-02-25}
  s.summary = %q{A carbon model}
  s.description = %q{A software model in Ruby for the greenhouse gas emissions of a bus trip}
  s.email = %q{andy@rossmeissl.net}
  s.homepage = %q{https://github.com/brighterplanet/bus_trip}
  s.rdoc_options = ["--charset=UTF-8"]
  
  s.require_paths = ["lib"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  s.add_runtime_dependency 'earth', '~>1.1.0'
  s.add_runtime_dependency 'emitter', '~> 1.1.0'
  s.add_development_dependency 'sniff', '~> 1.1.1'
end
