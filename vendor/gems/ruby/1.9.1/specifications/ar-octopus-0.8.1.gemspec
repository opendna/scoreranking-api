# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "ar-octopus"
  s.version = "0.8.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Thiago Pradi", "Mike Perham", "Gabriel Sobrinho"]
  s.date = "2014-01-28"
  s.description = "This gem allows you to use sharded databases with ActiveRecord. This also provides a interface for replication and for running migrations with multiples shards."
  s.email = ["tchandy@gmail.com", "mperham@gmail.com", "gabriel.sobrinho@gmail.com"]
  s.homepage = "https://github.com/tchandy/octopus"
  s.licenses = ["MIT"]
  s.post_install_message = "Important: If you are upgrading from < Octopus 0.5.0 you need to run:\n$ rake octopus:copy_schema_versions\n\nOctopus now stores schema version information in each shard and migrations will not work properly unless this task is invoked."
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Easy Database Sharding for ActiveRecord"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 3.2.0"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.2.0"])
      s.add_development_dependency(%q<rake>, [">= 0.8.7"])
      s.add_development_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_development_dependency(%q<mysql2>, ["> 0.3"])
      s.add_development_dependency(%q<pg>, [">= 0.11.0"])
      s.add_development_dependency(%q<sqlite3>, [">= 1.3.4"])
      s.add_development_dependency(%q<pry-debugger>, [">= 0"])
      s.add_development_dependency(%q<appraisal>, [">= 0.3.8"])
    else
      s.add_dependency(%q<activerecord>, [">= 3.2.0"])
      s.add_dependency(%q<activesupport>, [">= 3.2.0"])
      s.add_dependency(%q<rake>, [">= 0.8.7"])
      s.add_dependency(%q<rspec>, [">= 2.0.0"])
      s.add_dependency(%q<mysql2>, ["> 0.3"])
      s.add_dependency(%q<pg>, [">= 0.11.0"])
      s.add_dependency(%q<sqlite3>, [">= 1.3.4"])
      s.add_dependency(%q<pry-debugger>, [">= 0"])
      s.add_dependency(%q<appraisal>, [">= 0.3.8"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 3.2.0"])
    s.add_dependency(%q<activesupport>, [">= 3.2.0"])
    s.add_dependency(%q<rake>, [">= 0.8.7"])
    s.add_dependency(%q<rspec>, [">= 2.0.0"])
    s.add_dependency(%q<mysql2>, ["> 0.3"])
    s.add_dependency(%q<pg>, [">= 0.11.0"])
    s.add_dependency(%q<sqlite3>, [">= 1.3.4"])
    s.add_dependency(%q<pry-debugger>, [">= 0"])
    s.add_dependency(%q<appraisal>, [">= 0.3.8"])
  end
end
