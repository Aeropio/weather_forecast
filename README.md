# Weather forecaster app with Ruby on Rails

## Description
This is a simple weather app built on Ruby on Rails. 
It utilizes the OpenWeather API to fetch weather data based on provided zip codes and country codes. 
The application caches data to improve performance.

## Requirements:
```sh
Ruby 3.0.6p216
Rails 6.1.7.6
```

## Getting Started
1. Clone the repository
```sh
% git clone git@github.com:Aeropio/weather_forecast.git
```

2. Install dependencies:
```sh
% bundle install
```

3. Set up your environment:
Set the OPENWEATHER_API_KEY environment variable. You can use a .env file for local development.

## Usage
1. Start the Rails server:
```sh
% rails server
```
2. Navigate to the root page in your browser.
3. Input the zip code and select the country.
3. Upon submission of the form, if both the zip code and country code are valid, it will display the temperature results.

## System dependencies
### Caching: 
The application uses Rails caching to store countries data and cache forecast details for 30 minutes for all subsequent requests by zip and country codes.

### Running test suite
```sh
% bundle exec rspec
```