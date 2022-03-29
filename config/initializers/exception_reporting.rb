# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

def report_exception(exception, report_to_ets = true, meta = {})
  report_exception_to_screen(exception)
  report_exception_to_ets(exception, meta) if report_to_ets
end

def report_exception_to_screen(exception)
  Rails.logger.unknown exception.inspect
  Rails.logger.unknown Array(exception.backtrace).join("\n") if exception.respond_to?(:backtrace)
end

# rubocop:disable Metrics/MethodLength
def report_exception_to_ets(exception, context = {})
  if defined?(Bugsnag)
    Bugsnag.notify exception do |report|
      report.add_tab :context, context if context.present?
    end
  end
  if defined?(Sentry)
    Sentry.with_scope do |scope|
      scope.set_tags(context) if context.present?
      if exception.is_a?(String)
        Sentry.capture_message(exception)
      else
        Sentry.capture_exception(exception)
      end
    end
  end
rescue StandardError => e
  report_exception(e, false)
end
# rubocop:enable Metrics/MethodLength
