require 'rubygems'
require 'rake'

version = File.read('VERSION')
 
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version = version
    gem.name = "ruby-tables"
    gem.summary = %Q{Lua tables for Ruby}
    gem.description = %Q{The table data structure from lua implemented in Ruby}
    gem.email = "nick.loves.rails@gmail.com"
    gem.homepage = "http://github.com/Abica/ruby-tables"
    gem.authors = [ "Nicholas Wright" ]
    gem.add_development_dependency "rspec", ">= 1.2.2"
    gem.has_rdoc = true
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
 
task :default => :spec
 
require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby-tables #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
