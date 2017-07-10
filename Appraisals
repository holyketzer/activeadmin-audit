require 'yaml'

ruby_versions = %w(2.3.4 2.4.1)

rails_versions = %w(4.2.9 5.1.2)
activeadmin_versions = %w(1.0.0)
paper_trail_versions = %w(5.2.3)

rails_versions.each do |rails_version|
  activeadmin_versions.each do |activeadmin_version|
    paper_trail_versions.each do |paper_trail_version|
      appraise "rails_#{rails_version}_active_admin_#{activeadmin_version}_paper_trail_#{paper_trail_version}" do
        gem 'rails', rails_version
        gem 'activeadmin', activeadmin_version
        gem 'paper_trail', paper_trail_version
      end
    end
  end
end

travis = ::YAML.dump(
  'language' => 'ruby',
  'rvm' => ruby_versions,
  'before_install' => [
    'gem update --remote bundler',
  ],
  'install' => [
    'bundle install --retry=3'
  ],
  'script'  => [
    'bundle exec rake dummy:prepare',
    'bundle exec rspec',
  ],
  'gemfile' => Dir.glob('gemfiles/*.gemfile'),
  'addons' => {
    'code_climate' => {
      'repo_token' => 'fa6eecd14a238a6a4326b5b001bab6b0acf5170da237779800fa4935ad1c0026'
    }
  }
)

::File.open('.travis.yml', 'w+') do |file|
  file.write(travis)
end
