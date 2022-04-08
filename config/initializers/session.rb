# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
                                        key: '_agnessa',
                                        domain: :all,
                                        tld_length:  Rails.configuration.application.default_url_options.fetch(:host).split('.').count
