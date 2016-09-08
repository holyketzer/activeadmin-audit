begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ActiveAdminAudit'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.md')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)

load 'rails/tasks/engine.rake'
load 'rails/tasks/statistics.rake'

require 'bundler/gem_tasks'

namespace :dummy do
  desc 'Setup dummy app database'
  task :prepare do
    # File.expand_path is executed directory of generated Rails app
    rakefile = File.expand_path('Rakefile', dummy_path)
    command = "rake -f '%s' db:schema:load RAILS_ENV=test" % rakefile
    sh(command) unless ENV['DISABLE_CREATE']
  end

  def dummy_path
    rel_path = ENV['DUMMY_APP_PATH'] || 'spec/dummy'
    if @current_path.to_s.include?(rel_path)
      @current_path
    else
      @current_path = File.expand_path(rel_path)
    end
  end
end
