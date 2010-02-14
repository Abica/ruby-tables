require 'rubygems'
require 'rake'
 
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.version = "0.1.0"
    gem.name = "ruby-tables"
    gem.summary = %Q{Ruby implementation of lua tables}
    gem.description = %Q{A table data structure implemented in ruby}
    gem.email = "nick.loves.rails@gmail.com"
    gem.homepage = "http://github.com/Abica/ruby-tables"
    gem.authors = [ "Nicholas Wright" ]
    gem.add_development_dependency "rspec", ">= 1.2.2"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
 
task :default => :spec
 
require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
 
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby-tables #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end