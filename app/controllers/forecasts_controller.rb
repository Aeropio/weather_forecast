class ForecastsController < ApplicationController
  def show
    if params[:zip_code] and params[:country_code]
      @weather_cache_key = "#{params[:zip_code]},#{params[:country_code]}"
      @is_weather_cached = Rails.cache.exist?(@weather_cache_key)
      @weather = Rails.cache.fetch(@weather_cache_key, expires_in: 30.minutes) do
        WeatherService.new.execute(params[:zip_code], params[:country_code])        
      end
    else
    
    end
    respond_to do |format|
      format.html
      format.json { render json: @weather } # Render JSON response
    end
  end
end

