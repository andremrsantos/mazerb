require "bundler/gem_tasks"
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs << ["lib","spec"]
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = true
end

task :build_maze do
  require 'mazerb'

  builder = Mazerb::Iterator::MazeBuilder.new(20, 20, Mazerb::Iterator::GrowingTree)
  puts builder.build
end

task :swing do
  require 'mazerb'
  require 'mazerb/view/swimg'


  Example.new
end