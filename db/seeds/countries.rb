# List of current countries with ISO codes
COUNTRIES = [
  { name: 'United States', code: 'US' },
  { name: 'United Kingdom', code: 'GB' },
  { name: 'Canada', code: 'CA' },
  { name: 'Australia', code: 'AU' },
  { name: 'Germany', code: 'DE' },
  { name: 'France', code: 'FR' },
  { name: 'Japan', code: 'JP' },
  { name: 'Spain', code: 'ES' },
  { name: 'Italy', code: 'IT' },
  { name: 'Brazil', code: 'BR' },
  { name: 'Argentina', code: 'AR' },
  { name: 'Mexico', code: 'MX' },
  { name: 'Sweden', code: 'SE' },
  { name: 'Netherlands', code: 'NL' },
  { name: 'Norway', code: 'NO' },
  { name: 'Denmark', code: 'DK' },
  { name: 'Finland', code: 'FI' },
  { name: 'Ireland', code: 'IE' },
  { name: 'Portugal', code: 'PT' },
  { name: 'Russia', code: 'RU' },
  { name: 'China', code: 'CN' },
  { name: 'South Korea', code: 'KR' },
  { name: 'India', code: 'IN' },
  { name: 'South Africa', code: 'ZA' },
  { name: 'New Zealand', code: 'NZ' }
]

COUNTRIES.each do |country|
  Country.find_or_create_by!(code: country[:code]) do |c|
    c.name = country[:name]
  end
end 