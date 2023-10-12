# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'countries'

ISO3166::Country.all_names_with_codes.each do |country|
  begin
    Country.create!(name: country[0], code: country[1])
    Rails.logger.info "Country '#{country[0]}' seeded successfully!"
  rescue ActiveRecord::RecordNotUnique => e
    Rails.logger.warn "Skipping '#{country[0]}' due to uniqueness constraint violation."
    
  rescue StandardError => e
    Rails.logger.error "Error seeding '#{country[0]}': #{e.message}"
  end
end

Rails.logger.info 'Countries data seeding completed.'
