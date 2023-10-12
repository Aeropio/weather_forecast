# spec/client/api_caller_spec.rb

require 'rails_helper'

describe External::Client::ApiCaller do
  let(:api_caller) { External::Client::ApiCaller.new('https://api.openweathermap.org') }

  describe '#get_request' do
    context 'when API call is successful' do
      it 'returns response body' do
        response = api_caller.get_request('/geo/1.0/zip?', { zip: '500004,IN' })
        expect(JSON.parse(response)).to eq({"zip"=>"500004", "name"=>"Hyderabad", "lat"=>17.3872, "lon"=>78.4621, "country"=>"IN"})
      end
    end

    context 'when a Faraday error occurs' do
      it 'logs the error and re-raises it' do
        allow(api_caller).to receive(:connection).and_raise(Faraday::Error.new('Some Faraday error'))

        expect(Rails.logger).to receive(:error).with('An error occurred: Some Faraday error')
        expect {
          api_caller.get_request('/geo/1.0/zip?', { zip: '500004,IN' })
        }.to raise_error(Faraday::Error, 'Some Faraday error')
      end
    end
  end
end
