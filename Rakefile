# contents:
#
# Copyright © 2005 Nikolai Weibull <nikolai@bitwi.se>



require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'

PackageName = 'ruby-lisp'
PackageVersion = '1.0.0'

desc 'Default task'
task :default => [:test]

desc 'Extract embedded documentation and build HTML documentation'
task :doc => [:rdoc]
task :rdoc => FileList['lib/**/*.rb']

desc 'Clean up by removing all generated files, e.g., documentation'
task :clean => [:clobber_rdoc]

Rake::TestTask.new do |t|
  t.test_files = ['test/iteration.rb']
  t.verbose = true
end

RDocDir = 'api'

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = RDocDir
  rdoc.title = 'Ruby-Lisp'
  rdoc.options = ['--charset UTF-8']
  rdoc.rdoc_files.include('lib/**/*.rb')
end
