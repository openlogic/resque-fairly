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
    gem.email = "cameron.mauch@roguewave.com"
    gem.homepage = "http://github.com/openlogic/resque-fairly"
    gem.authors = ["D Cameron Mauch", "Peter Williams"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
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
