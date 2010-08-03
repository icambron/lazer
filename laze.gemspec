require 'date'
require 'rake'
Gem::Specification.new do |s|
  s.name = %q{laze-test}
  s.version = "0.0.0"
  s.date = Date.today.to_s
  s.summary = %q{Lazy Enumerators for Ruby}
  s.description = %q{Laze is a set lazy implemetations of Enumerable methods}
  s.authors = [%q{Isaac Camberon}, %q{Jonathan Palmer}]
#  s.email = %q{rmagick@rubyforge.org}
  s.homepage = %q{http://github.com/icambron/laze}
  s.files = FileList["{bin,lib}/**/*"].to_a
  s.require_path = "lib"
  s.has_rdoc = false
  s.required_ruby_version = '>= 1.9.1'
end
