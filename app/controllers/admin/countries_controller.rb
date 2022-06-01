class Admin::CountriesController < Admin::ApplicationController
  before_action :authorize_admin

  def index
    countries = paginate Country.all # .order('archived_at desc')
    render locals: { countries: countries }
  end

  def new
    render locals: { country: Country.new }
  end

  def create
    country = Country.create! country_params
    redirect_back fallback_location: admin_countries_url, notice: 'Country was successfully updated.'
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Country
    render :new, locals: { country: e.record }
  end

  def edit
    render locals: { country: country }
  end

  def update
    country.update!(country_params)
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

  def add_type
  end

  def remove_type
  end

  private

  def per_page_default
    500
  end

  def country
    @country ||= Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(:iso_code, :title_ru, :title_en, { id_types: [] })
  end
end
