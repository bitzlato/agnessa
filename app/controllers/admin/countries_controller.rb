class Admin::CountriesController < Admin::ApplicationController
  before_action :authorize_admin

  def index
    countries = paginate Country.all # .order('archived_at desc')
    render locals: { countries: countries }
  end

  def create; end

  def update
    country.update!(admin_country_params)
    redirect_back fallback_location: admin_countries_url, notice: 'Country was successfully updated.'
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Country
    render :edit, locals: { member: Country }
  end

  def restore
    country.restore!
    redirect_back fallback_location: admin_countries_url, notice: 'Country was successfully restored.'
  end

  def archive
    country.archive!
    redirect_back fallback_location: admin_countries_url, notice: 'Country was successfully archived.'
  end

  private

  def country
    @country ||= Country.find(params[:id])
  end

  def admin_country_params
    params.require(:country).permit(:code, :title_ru, :title_en, { id_types: [] })
  end
end
