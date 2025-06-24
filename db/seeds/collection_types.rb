# Collection Types
puts "Creating collection types..."

collection_types = [
  {
    name: "Music",
    description: "Music albums, singles, and other audio recordings"
  },
  {
    name: "Series",
    description: "TV series, movies, and episodic content"
  },
  {
    name: "Books",
    description: "Books, novels, and other written publications"
  }
]

collection_types.each do |collection_type_attrs|
  collection_type = CollectionType.find_or_create_by(name: collection_type_attrs[:name]) do |ct|
    ct.description = collection_type_attrs[:description]
  end
  
  if collection_type.persisted?
    puts "✓ Collection type '#{collection_type.name}' created/updated"
  else
    puts "✗ Failed to create collection type '#{collection_type_attrs[:name]}': #{collection_type.errors.full_messages.join(', ')}"
  end
end

puts "Collection types seeding completed!" 