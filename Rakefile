require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sneakers"
    gem.summary = %Q{A wrapper for building asynchronous apps in a synchronous way}
    gem.description = %Q{A wrapper built to help speed up the development of asynchronous apps, and make them easier to maintain.}
    gem.email = "jay.palekar@gmail.com"
    gem.homepage = "http://github.com/bluejay/sneakers"
    gem.authors = ["Jay Palekar"]
    
    gem.add_dependency "rack", ">= 1.2.1"
    gem.add_dependency "eventmachine", ">= 0.12.10"
    
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "yard", ">= 0"
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

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yardoc do
    abort "YARD is not available. In order to run yardoc, you must: sudo gem install yard"
  end
end
