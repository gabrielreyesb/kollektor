# Americas
americas = [
  { name: 'United States', code: 'US' },
  { name: 'Canada', code: 'CA' },
  { name: 'Mexico', code: 'MX' },
  { name: 'Brazil', code: 'BR' },
  { name: 'Argentina', code: 'AR' },
  { name: 'Chile', code: 'CL' },
  { name: 'Colombia', code: 'CO' },
  { name: 'Peru', code: 'PE' }
]

# Europe
europe = [
  { name: 'United Kingdom', code: 'GB' },
  { name: 'Germany', code: 'DE' },
  { name: 'France', code: 'FR' },
  { name: 'Italy', code: 'IT' },
  { name: 'Spain', code: 'ES' },
  { name: 'Netherlands', code: 'NL' },
  { name: 'Sweden', code: 'SE' },
  { name: 'Norway', code: 'NO' },
  { name: 'Denmark', code: 'DK' },
  { name: 'Ireland', code: 'IE' },
  { name: 'Portugal', code: 'PT' }
]

# Asia
asia = [
  { name: 'Japan', code: 'JP' },
  { name: 'South Korea', code: 'KR' },
  { name: 'China', code: 'CN' },
  { name: 'India', code: 'IN' },
  { name: 'Thailand', code: 'TH' },
  { name: 'Vietnam', code: 'VN' },
  { name: 'Singapore', code: 'SG' },
  { name: 'Malaysia', code: 'MY' }
]

# Combine all regions
all_countries = americas + europe + asia

# Create countries
all_countries.each do |country_data|
  Country.find_or_create_by!(name: country_data[:name]) do |country|
    country.code = country_data[:code]
    puts "Created country: #{country.name} (#{country.code})"
  end
end 