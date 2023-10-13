class ApplicationController < ActionController::Base
    rescue_from(Faraday::Error) do |e|
        error = {}
        error[:title] = 'FaradayError'
        error[:detail] = e.message
        render json: { errors: error }, status: e.response[:status]
    end
end
