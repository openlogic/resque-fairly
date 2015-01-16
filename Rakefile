require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "resque-fairly"
    gem.summary = "Fair queue processing for Resque"
    gem.description = <<DESC
Normally resque processes queues in a fixed order.  This can lead to jobs in queues at the end of the list not getting process for very long periods.  resque-fairly provides a mechanism where by workers are distributed across the set of queues with pending jobs fairly.  This results in a much more predictable mean time to handling for jobs in queues that are not the first in the list.
DESC
    gem.email = "pezra@barelyenough.org"
    gem.homepage = "http://github.com/pezra/resque-fairly"
    gem.authors = ["Peter Williams"]
    gem.add_dependency "resque", "~>1.0"
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "resque-fairly #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
