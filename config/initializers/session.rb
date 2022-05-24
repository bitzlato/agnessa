# frozen_string_literal: true

key = '_agnessa'
key += '_' + Rails.env unless Rails.env.production?
Rails.application.config.session_store :cookie_store,
                                        key: key,
                                        domain: :all,
                                        tld_length:  Rails.configuration.application.default_url_options.fetch(:host).split('.').count
