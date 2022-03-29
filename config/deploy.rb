# frozen_string_literal: true

lock '3.16'

set :user, 'app'

set :roles, %w[app db].freeze

set :repo_url, ENV.fetch('DEPLOY_REPO', `git remote -v | grep origin | head -1 | awk  '{ print $2 }'`.chomp) if ENV['USE_LOCAL_REPO'].nil?
set :keep_releases, 10

set :linked_files, [".env"]
set :linked_dirs, %w[log tmp/pids tmp/cache tmp/sockets secrets public/uploads]
set :config_files, fetch(:linked_files)

set :deploy_to, -> { "/home/#{fetch(:user)}/#{fetch(:application)}" }

set :disallow_pushing, true

set :db_dump_extra_opts, '--force'

default_branch = 'master'
current_branch = `git rev-parse --abbrev-ref HEAD`.chomp

if ENV.key? 'BRANCH'
  set :branch, ENV.fetch('BRANCH')
elsif default_branch == current_branch
  set :branch, default_branch
else
  ask(:branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp })
end

set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip

set :conditionally_migrate, true # Only attempt migration if db/migrate changed - not related to Webpacker, but a nice thing

set :db_local_clean, false
set :db_remote_clean, true

set :app_version, SemVer.find.to_s
set :current_version, `git rev-parse HEAD`.strip

if Gem.loaded_specs.key?('capistrano-sentry')
  set :sentry_organization, ENV['SENTRY_ORGANIZATION']
  set :sentry_release_version, -> { [fetch(:app_version), fetch(:current_version)].compact.join('-') }
end


set :bugsnag_api_key, ENV['BUGSNAG_API_KEY']
set :app_version, `semver`.strip
set :assets_roles, []
set :init_system, :systemd
set :systemd_mailer_role, :mailer

if Gem.loaded_specs.key?('capistrano-sentry')
  before 'deploy:starting', 'sentry:validate_config'
  after 'deploy:published', 'sentry:notice_deployment'
end

after 'deploy:publishing', 'systemd:puma:reload-or-restart'
after 'deploy:publishing', 'systemd:sidekiq:reload-or-restart'

desc 'Setup deploy'
task :setup => [:push_credentials, 'systemd:puma:setup']

desc 'Push config/master.key and config/credentials/STAGE.key to stage'
task :push_credentials => 'deploy:check:directories' do
  on roles(:app) do
    execute :mkdir, "-pv", "#{shared_path}/config"
    # upload! 'config/master.key', "#{shared_path}/config/master.key"
    execute :mkdir, "-pv", "#{shared_path}/config/credentials"
    upload! "config/credentials/#{fetch(:rails_env)}.key", "#{shared_path}/config/credentials/#{fetch(:rails_env)}.key"
  end
end

if defined? Slackistrano
  Rake::Task['deploy:starting'].prerequisites.delete('slack:deploy:starting')
  set :slackistrano,
      klass: Slackistrano::CustomMessaging,
      channel: ENV['SLACKISTRANO_CHANNEL'],
      webhook: ENV['SLACKISTRANO_WEBHOOK']

  # best when 75px by 75px.
  set :slackistrano_thumb_url, 'https://bitzlato.com/wp-content/uploads/2020/12/logo.svg'
  set :slackistrano_footer_icon, 'https://github.githubassets.com/images/modules/logos_page/Octocat.png'
end

namespace :rake do
  desc "Run a task on a remote server."
  # run like: cap staging rake:invoke task=a_certain_task
  task :invoke do
    run("cd #{deploy_to}/current; /usr/bin/env rake #{ENV['task']} RAILS_ENV=#{rails_env}")
  end
end

# Removed rake, bundle, gem
# Added rails.
# rake has its own dotenv requirement in Rakefile
set :dotenv_hook_commands, %w{rails rake ruby}

Capistrano::DSL.stages.each do |stage|
  after stage, 'dotenv:hook'
end
