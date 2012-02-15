# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{deep_cloning}
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["emschwar", "DefV", "DerNalia", "TheLindyHop"]
  s.date = %q{2012-02-15}
  s.description = %q{Deep copying for ActiveRecord objects}
  s.email = %q{theprecognition@gmail.com}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".rvmrc",
    "Gemfile",
    "Gemfile.lock",
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
  s.homepage = %q{http://github.com/dernalia/deep_cloning}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.3}
  s.summary = %q{Deep copying for ActiveRecord objects}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>, ["= 2.3.8"])
      s.add_runtime_dependency(%q<riot>, [">= 0"])
      s.add_runtime_dependency(%q<sqlite3>, [">= 0"])
      s.add_runtime_dependency(%q<ruby-debug>, [">= 0"])
      s.add_runtime_dependency(%q<awesome_print>, [">= 0"])
      s.add_runtime_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<i18n>, [">= 0"])
      s.add_runtime_dependency(%q<multi_json>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_development_dependency(%q<activerecord>, [">= 2.3.2"])
      s.add_development_dependency(%q<riot>, [">= 0.10.2"])
    else
      s.add_dependency(%q<rails>, ["= 2.3.8"])
      s.add_dependency(%q<riot>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<i18n>, [">= 0"])
      s.add_dependency(%q<multi_json>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 2.3.2"])
      s.add_dependency(%q<riot>, [">= 0.10.2"])
    end
  else
    s.add_dependency(%q<rails>, ["= 2.3.8"])
    s.add_dependency(%q<riot>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<i18n>, [">= 0"])
    s.add_dependency(%q<multi_json>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 2.3.2"])
    s.add_dependency(%q<riot>, [">= 0.10.2"])
  end
end

