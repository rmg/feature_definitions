# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

unless ENV['TRAVIS']
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
    gem.name = "lazy_const"
    gem.homepage = "http://github.com/rmg/lazy_const"
    gem.license = "MIT"
    gem.summary = %Q{A little Ruby gem for defining lazy evaluated constants.}
    gem.description = %Q{Allows you to define lazy evaluated, constant-like instances of your class.}
    gem.email = "r.m.graham@gmail.com"
    gem.authors = ["Ryan Graham"]
    # dependencies defined in Gemfile
  end
  Jeweler::RubygemsDotOrgTasks.new

  require 'rdoc/task'
  Rake::RDocTask.new do |rdoc|
    version = File.exist?('VERSION') ? File.read('VERSION') : ""

    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "lazy_const #{version}"
    rdoc.rdoc_files.include('README*')
    rdoc.rdoc_files.include('lib/**/*.rb')
  end
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

task :default => :test

