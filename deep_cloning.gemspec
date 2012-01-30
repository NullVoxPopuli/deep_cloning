# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{deep_cloning}
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["emschwar", "DefV"]
  s.date = %q{2010-01-21}
  s.description = %q{Deep copying for ActiveRecord objects}
  s.email = %q{eric.schwartz@centro.net}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "MIT-LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "about.yml",
     "deep_cloning.gemspec",
     "lib/deep_cloning.rb",
     "test/database.yml",
     "test/debug.log",
     "test/deep_cloning.sqlite.db",
     "test/deep_cloning_test.rb",
     "test/fixtures/gold_piece.rb",
     "test/fixtures/matey.rb",
     "test/fixtures/parrot.rb",
     "test/fixtures/pirate.rb",
     "test/fixtures/treasure.rb",
     "test/schema.rb",
     "test/teststrap.rb"
  ]
  s.homepage = %q{http://github.com/emschwar/deep_cloning}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Deep copying for ActiveRecord objects}
  s.test_files = [
    "test/fixtures/gold_piece.rb",
     "test/fixtures/parrot.rb",
     "test/fixtures/treasure.rb",
     "test/fixtures/matey.rb",
     "test/fixtures/pirate.rb",
     "test/schema.rb",
     "test/teststrap.rb",
     "test/deep_cloning_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<activerecord>, [">= 2.3.2"])
      s.add_development_dependency(%q<riot>, [">= 0.10.2"])
    else
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 2.3.2"])
      s.add_dependency(%q<riot>, [">= 0.10.2"])
    end
  else
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 2.3.2"])
    s.add_dependency(%q<riot>, [">= 0.10.2"])
  end
end

