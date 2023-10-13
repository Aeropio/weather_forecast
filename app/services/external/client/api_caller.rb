module External
  module Client
    class ApiCaller
        attr_reader :connection
        def initialize(url)
            @connection = Faraday.new(url) do |builder|
              # Sets the Content-Type header to application/json on each request.
              # Also, if the request body is a Hash, it will automatically be encoded as JSON.
              builder.request :json
              # Parses JSON response bodies.
              # If the response body is not valid JSON, it will raise a Faraday::ParsingError.
              builder.response :json
              # Raises an error on 4xx and 5xx responses.
              builder.response :raise_error
              # Logs requests and responses.
              # By default, it only logs the request method and URL, and the request/response headers.
              # builder.response :logger
            end
        end
        
        def get_request(path, get_parameters)
            get_api(path, get_parameters)
        end
        
        private
        
        def get_api(path, parameters = {})
          response = connection.get(path, parameters)
      
          if response.success?
            response.body
          else
            raise StandardError.new("HTTP error: #{response.status}")
          end
        end
    end
  end
end
