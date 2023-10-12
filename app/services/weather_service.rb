class WeatherService
  WEATHER_BASE_URL = "https://api.openweathermap.org"
  COORDINATES_PATH = "/geo/1.0/zip?"
  FETCH_WEATHER_PATH = "/data/2.5/weather?"
  
  # TODO singleton, json parse error and api key in credentials file
  def initialize
    @connection ||= initialize_connection
  end
  
  def execute(post_code, country_code)
    # sample data received from geo api to get lat and long
    # {"zip":"500004","name":"Hyderabad","lat":17.3872,"lon":78.4621,"country":"IN"}
    begin
      coordinates_api_response = get_coordinates(post_code, country_code)
      weather_api_response = get_weather(coordinates_api_response["lat"], coordinates_api_response["lon"])
    rescue StandardError => e
      Rails.logger.error "Error: #{e.message}"
    end
  end
  
  private
  
  def  get_weather(latitude, longitude, units = "metric")
    response = @connection.get_request(FETCH_WEATHER_PATH, {
                  appid: ENV.fetch("OPENWEATHER_API_KEY"),
                  lat: latitude,
                  lon: longitude,
                  units: units,
                })
    response.body
  end
  
  def get_coordinates(post_code, country_code)
    # zipcode combined with country code eg: "500004,IN"
    zip_country_code = "#{post_code},#{country_code}"
    @connection.get_request(COORDINATES_PATH, {
      appid: ENV.fetch("OPENWEATHER_API_KEY"),
      zip: zip_country_code
    })
  end
  
  def initialize_connection
    External::Client::ApiCaller.new(WEATHER_BASE_URL)
  end
end