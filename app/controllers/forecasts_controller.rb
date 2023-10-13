class ForecastsController < ApplicationController
  def show
    @weather_cache_key = "#{params[:zip_code]},#{params[:country_code]}"
    @is_weather_cached = Rails.cache.exist?(@weather_cache_key)
    
    @weather = Rails.cache.fetch(@weather_cache_key, expires_in: 30.minutes) do
        weather = WeatherService.new.execute(params[:zip_code], params[:country_code])
        weather if weather.is_a?(OpenStruct) # Only cache if it's a Weather object
    end
   
    if @weather
      render json: { data: weather_hash }, status: :ok
    else
      render json: { errors: "Error fetching weather data" }, status: :internal_server_error
    end
  end

  private

  def weather_hash
    {
      temperature: @weather.temperature,
      temperature_min: @weather.temperature_min,
      temperature_max: @weather.temperature_max,
      humidity: @weather.humidity,
      pressure: @weather.pressure,
      description: @weather.description,
      is_weather_cached: @is_weather_cached
    }
  end
end
