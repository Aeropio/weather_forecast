# spec/requests/forecasts_spec.rb

require 'rails_helper'

RSpec.describe 'Forecasts', type: :request do
  describe 'GET /forecasts/show' do
    before do
      Rails.cache.write('countries_data', { 'Country1' => 'code1', 'Country2' => 'code2' })
    end

    after do
      Rails.cache.delete('countries_data')
    end

    context 'with valid params' do
      it 'fetches weather data and sets flash notice' do
        allow_any_instance_of(WeatherService).to receive(:execute).and_return(OpenStruct.new(
          temperature: 20,
          temperature_min: 15,
          temperature_max: 25,
          humidity: 50,
          pressure: 1010,
          description: 'Partly cloudy'
        ))

        get '/forecasts/show', params: { zip_code: '12345', country: 'Country1' }

        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid params' do
      it 'does not fetch weather data and does not set flash notice' do
        get '/forecasts/show', params: { zip_code: '12345' }

        expect(response).to have_http_status(:success)
        expect(flash[:notice]).to be_nil
      end
    end
  end
end
