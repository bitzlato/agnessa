class Admin::CountriesController < Admin::ApplicationController
  before_action :authorize_admin

  def index
    countries = paginate Country.order('title_ru asc')
    render locals: { countries: countries }
  end

  def new
    country = Country.new(available_documents: Rails.application.config.application.available_documents)
    render locals: { country: country }
  end

  def create
    country = Country.create! country_params
    redirect_back fallback_location: admin_countries_url, notice: 'Country was successfully created.'
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Country
    render :new, locals: { country: e.record }
  end

  def edit
    render locals: { country: country }
  end

  def update
    country.update!(country_params)
    if request.xhr?
      render locals: { country: country, document: country_params[:document] }
    else
      redirect_back fallback_location: admin_countries_url, notice: 'Country was successfully updated.'
    end
  rescue ActiveRecord::RecordInvalid => e
    raise e unless e.record.is_a? Country
    render :edit, locals: { country: country }
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

  def per_page_default
    500
  end

  def country
    @country ||= Country.find(params[:id])
  end

  def country_params
    params.require(:country).permit(:iso_code, :title_ru, :document, :title_en,  :available_documents => [])
  end
end
