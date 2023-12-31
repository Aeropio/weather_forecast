# config/initializers/cache_seeding.rb

# Check if countries data is present in the cache
unless Rails.cache.read('countries_data')
  # If not present, seed the cache with countries data
  require 'countries'
  countries_data = ISO3166::Country.all_names_with_codes

  # Store countries data in the cache
  # key is country_name, value is country_code
  countries_data = countries_data.each_with_object({}) do |(name, code), hash|
    hash[name] = code
  end
  Rails.cache.write('countries_data', countries_data)
  Rails.logger.info 'Countries data seeded successfully in cache.'
end
