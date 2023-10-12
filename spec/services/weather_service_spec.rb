# spec/weather_service_spec.rb

require 'rails_helper'

RSpec.describe WeatherService, type: :service do
  let(:weather_service) { WeatherService.new }

  describe '#execute' do
    it 'fetches weather data' do
      # Stub the API calls
      allow(weather_service).to receive(:get_coordinates).and_return({"lat" => 17.3872, "lon" => 78.4621})
      allow(weather_service).to receive(:get_weather).and_return("Weather data")

      # Execute the method
      result = weather_service.execute("500004", "IN")

      expect(result).to eq("Weather data")
    end

    it 'logs errors' do
      # Stub the API calls to raise an error
      allow(weather_service).to receive(:get_coordinates).and_raise(StandardError.new("Some error"))

      # Capture logs
      expect(Rails.logger).to receive(:error).with("Error: Some error")

      # Execute the method
      weather_service.execute("500004", "IN")
    end
  end
end