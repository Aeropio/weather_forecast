class ForecastsController < ApplicationController
  rescue_from Faraday::Error, with: :handle_faraday_error

  def show
    if valid_params?
      @weather = fetch_weather_data
      flash[:notice] = weather_flash_message if @weather
      redirect_to root_path
    end

    respond_to do |format|
      format.html
      format.json { render json: @weather, status: :ok }
    end
  end

  private

  def handle_faraday_error(e)
    flash[:alert] = "Error fetching weather data: #{e.message}"
    redirect_to root_path
  end

  def valid_params?
    filtered_params = params.permit(:zip_code, :country)
    filtered_params[:zip_code].present? && filtered_params[:country].present?
  end

  def fetch_weather_data
    # Fetches the weather data for the given zip code and country code.
    country_code = get_country_code
    weather_cache_key = "#{params[:zip_code]},#{country_code}"
    @is_weather_cached = Rails.cache.exist?(weather_cache_key)

    Rails.cache.fetch(weather_cache_key, expires_in: 30.minutes) do
      weather_service.execute(params[:zip_code], country_code)
    end
  end

  def weather_flash_message
    <<~MESSAGE
      <br> The weather in #{params[:country]} with #{params[:zip_code]} post code is below: <br> <br> <br>
      Temperature: #{@weather.temperature} ℃
      Temperature Minimum: #{@weather.temperature_min} ℃
      Temperature Maximum: #{@weather.temperature_max} ℃
      Humidity: #{@weather.humidity}%
      Pressure: #{@weather.pressure} millibars
      Description: #{@weather.description}
      Is this weather result from cache? #{@is_weather_cached}
    MESSAGE
  end

  def get_country_code
    Rails.cache.read('countries_data').fetch(params[:country])
  end

  def weather_service
    @weather_service ||= WeatherService.new
  end
end
