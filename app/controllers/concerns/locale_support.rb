module LocaleSupport
  extend ActiveSupport::Concern

  included do
    before_action :set_locale
  end

  private

  def save_locale(locale)
    session[:locale] = @guessed_locale = available_locale locale
  end

  def set_locale
    I18n.locale = guessed_locale
  end

  def guessed_locale
    @guessed_locale ||= (request.respond_to?(:query_parameters) ? available_locale(request.query_parameters[:locale]) : nil) ||
      available_locale(params[:locale]) ||
      available_locale(session[:locale]) ||
      available_locale(current_user.try(:locale)) ||
      http_accept_language.preferred_language_from(I18n.available_locales) ||
      http_accept_language.compatible_language_from(I18n.available_locales) ||
      I18n.default_locale
  end

  def available_locales
    @available_locales ||= I18n.available_locales.map(&:to_s)
  end

  def available_locale(locale)
    locale if available_locales.include? locale
  end
end
