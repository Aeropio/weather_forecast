class ForecastsController < ApplicationController
  rescue_from Faraday::Error, with: :handle_faraday_error

  def show
    if params[:zip_code].present? && params[:country].present?
      fetch_weather_data(params[:zip_code], params[:country])
      flash[:notice] = weather_flash_message(params[:zip_code], params[:country]) if @weather
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
  
   #(zip_code, country)
  def weather_flash_message(zip_code, country)
    <<~MESSAGE
      <br> The weather in #{country} with #{zip_code} post code is below: <br> <br> <br>
      Temperature: #{@weather.temperature} ℃
      Temperature Minimum: #{@weather.temperature_min} ℃
      Temperature Maximum: #{@weather.temperature_max} ℃
      Humidity: #{@weather.humidity}%
      Pressure: #{@weather.pressure} millibars
      Description: #{@weather.description}
      Is this weather result from cache? #{@is_weather_cached}
    MESSAGE
  end

  def fetch_weather_data(zip_code, country)
    country_code = Rails.cache.read('countries_data')[country]
    @weather_cache_key = "#{zip_code},#{country_code}"
    @is_weather_cached = Rails.cache.exist?(@weather_cache_key)

    @weather = Rails.cache.fetch(@weather_cache_key, expires_in: 30.minutes) do
      weather = WeatherService.new.execute(zip_code, country_code)
      weather if weather.is_a?(OpenStruct) # Only cache if it's a Weather object
    end
  end
end
