class WeatherService
  WEATHER_BASE_URL = "https://api.openweathermap.org"
  COORDINATES_PATH = "/geo/1.0/zip?"
  FETCH_WEATHER_PATH = "/data/2.5/weather?"
  
  #TODO json parse error and put openweather api key in credentials file
  def initialize
    @connection ||= initialize_connection
  end
  
  def execute(post_code, country_code)
    # sample data received from geo api to get lat and long
    # {"zip":"500004","name":"Hyderabad","lat":17.3872,"lon":78.4621,"country":"IN"}
      coordinates_api_response = get_coordinates(post_code, country_code)
      response_body = get_weather(coordinates_api_response["lat"], coordinates_api_response["lon"])
      weather_data(response_body)
  end
  
  private
  
  def  get_weather(latitude, longitude, units = "metric")
    @connection.get_request(FETCH_WEATHER_PATH, {
      appid: ENV.fetch("OPENWEATHER_API_KEY"),
      lat: latitude,
      lon: longitude,
      units: units,
    })
   
  end
  
  def get_coordinates(post_code, country_code)
    # get latitude and longitude for a given zipcode, country
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
  
  def weather_data(response_body)
    weather = OpenStruct.new
    weather.temperature = response_body["main"]["temp"]
    weather.temperature_min = response_body["main"]["temp_min"]
    weather.temperature_max = response_body["main"]["temp_max"]
    weather.humidity = response_body["main"]["humidity"]
    weather.pressure = response_body["main"]["pressure"]
    weather.description = response_body["weather"][0]["description"]
    weather
  end
end