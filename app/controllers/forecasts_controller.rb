class ForecastsController < ApplicationController
  rescue_from Faraday::Error, with: :handle_faraday_error

  def show
    if params[:zip_code].present? && params[:country_code].present?
      fetch_weather_data(params[:zip_code], params[:country_code])
      flash[:notice] = weather_flash_message if @weather
    else
      render :show
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

  def weather_flash_message
    <<~MESSAGE
      Temperature: #{@weather.temperature} ℃
      Temperature Minimum: #{@weather.temperature_min} ℃
      Temperature Maximum: #{@weather.temperature_max} ℃
      Humidity: #{@weather.humidity}%
      Pressure: #{@weather.pressure} millibars
      Description: #{@weather.description}
      Is this weather result from cache? #{@is_weather_cached}
    MESSAGE
  end

  def fetch_weather_data(zip_code, country_code)
    @weather_cache_key = "#{zip_code},#{country_code}"
    @is_weather_cached = Rails.cache.exist?(@weather_cache_key)

    @weather = Rails.cache.fetch(@weather_cache_key, expires_in: 30.minutes) do
      weather = WeatherService.new.execute(zip_code, country_code)
      weather if weather.is_a?(OpenStruct) # Only cache if it's a Weather object
    end
  end
end
