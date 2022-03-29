# frozen_string_literal: true

set :stage, :production
set :rails_env, :production
fetch(:default_env)[:rails_env] = :production

set :disallow_pushing, false
set :application, -> { 'agnessa' }
set :deploy_to, -> { "/home/#{fetch(:user)}/#{fetch(:application)}" }


server ENV.fetch('AGNESSA_SERVER'),
       user: 'app',
       port: '22',
       roles: %w[app db].freeze,
       ssh_options: { forward_agent: true }
