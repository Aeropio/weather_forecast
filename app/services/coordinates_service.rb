class CoordinatesService
    def self.execute(post_code, country_code)
        conn = Faraday.new(url: 'http://httpbingo.org') do |builder|
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
          builder.response :logger
        end
        
        begin
          # Make a GET request
          response = connection.get(path, parameters)
          response = conn.get('/geo/1.0/zip?', {
                  appid: ENV.fetch("OPENWEATHER_API_KEY"),
                  zip: "#{post_code},#{country_code}",
                })
        
          # Check if the response was successful (status code 2xx)
          if response.success?
            # Process the successful response
            Rails.logger.info "Request was successful. Response body:\n#{response.body}"
          else
            # Handle non-successful response (4xx and 5xx)
            Rails.logger.error "Error: #{response.status}"
            Rails.logger.error "Response body: #{response.body}"
          end
        rescue Faraday::TimeoutError
          # Handle timeout error
          Rails.logger.error 'Timeout error'
        rescue Faraday::ConnectionFailed
          # Handle connection error
          Rails.logger.error 'Connection failed'
        rescue Faraday::Error => e
          # Handle other Faraday errors
          Rails.logger.error "An error occurred: #{e.message}"
        end
    end   
end