# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require_relative 'seeds/countries'

# Countries seed data
countries = [
  { name: 'United States', code: 'US' },
  { name: 'United Kingdom', code: 'UK' },
  { name: 'Canada', code: 'CA' },
  { name: 'Australia', code: 'AU' },
  { name: 'Germany', code: 'DE' },
  { name: 'France', code: 'FR' },
  { name: 'Spain', code: 'ES' },
  { name: 'Italy', code: 'IT' },
  { name: 'Japan', code: 'JP' },
  { name: 'Brazil', code: 'BR' },
  { name: 'Mexico', code: 'MX' },
  { name: 'Argentina', code: 'AR' },
  { name: 'Sweden', code: 'SE' },
  { name: 'Netherlands', code: 'NL' },
  { name: 'Ireland', code: 'IE' }
]

# Create countries if they don't exist
countries.each do |country_data|
  Country.find_or_create_by!(name: country_data[:name]) do |country|
    country.code = country_data[:code]
    puts "Created country: #{country.name}"
  end
end

puts "Seeding completed!"
