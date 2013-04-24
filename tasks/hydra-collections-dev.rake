require 'rspec/core'
require 'rspec/core/rake_task'
APP_ROOT="." # for jettywrapper
require 'jettywrapper'
ENV["RAILS_ROOT"] ||= 'spec/internal'

desc 'Spin up hydra-jetty and run specs'
task :ci => ['jetty:config'] do
  puts 'running continuous integration'
  jetty_params = Jettywrapper.load_config
  error = Jettywrapper.wrap(jetty_params) do
    Rake::Task['spec'].invoke
  end
  raise "test failures: #{error}" if error
end

desc "Run specs"
# Note: this is _not_ an RSpec::Core::RakeTask.  
# It's a regular rake task that calls the RSpec RakeTask that's defined in spec/support/lib/tasks/rspec.rake
task :spec => [:generate] do |t|
  focused_spec = ENV['SPEC'] ? " SPEC=#{File.join(GEM_ROOT, ENV['SPEC'])}" : ''
  within_test_app do
    system "rake myspec#{focused_spec}"
    abort "Error running hydra-collections" unless $?.success?
  end
end

desc "Create the test rails app"
task :generate do
  unless File.exists?('spec/internal/Rakefile')
    puts "Generating rails app"
    `rails new spec/internal`
    puts "Copying gemfile"
    `cp spec/support/Gemfile spec/internal`
    puts "Copying generator"
    `cp -r spec/support/lib/generators spec/internal/lib`
    Bundler.with_clean_env do
      within_test_app do
        puts "Bundle install"
        `bundle install`
        puts "running test_app_generator"
        system "rails generate test_app"

        puts "running migrations"
        puts `rake db:migrate db:test:prepare`
      end
    end
  end
  puts "Done generating test app"
end

desc "Clean out the test rails app"
task :clean do
  puts "Removing sample rails app"
  `rm -rf spec/internal`
end

def within_test_app
  FileUtils.cd('spec/internal')
  yield
  FileUtils.cd('../..')
end

namespace :meme do
  desc "configure jetty to generate checksums"
  task :config do
  end
end
