# spec/services/weather_service_spec.rb

require 'rails_helper'

RSpec.describe WeatherService, type: :service do
  describe '#execute' do
    let(:service) { WeatherService.new }

    before do
      allow(service).to receive(:get_coordinates).and_return({
        "lat" => 17.3872,
        "lon" => 78.4621
      })

      allow(service).to receive(:get_weather).and_return({
        "main" => {
          "temp" => 20,
          "temp_min" => 15,
          "temp_max" => 25,
          "humidity" => 50,
          "pressure" => 1010
        },
        "weather" => [{
          "description" => "Partly cloudy"
        }]
      })
    end

    it 'fetches weather data for a given post code and country code' do
      weather = service.execute('500004', 'IN')

      expect(weather.temperature).to eq(20)
      expect(weather.temperature_min).to eq(15)
      expect(weather.temperature_max).to eq(25)
      expect(weather.humidity).to eq(50)
      expect(weather.pressure).to eq(1010)
      expect(weather.description).to eq('Partly cloudy')
    end
  end
end
