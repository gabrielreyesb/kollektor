# Genres
puts "Creating genres..."

# Get collection types
music_collection = CollectionType.find_by(name: "Music")
series_collection = CollectionType.find_by(name: "Series")

if music_collection
  music_genres = [
    "Rock", "Pop", "Jazz", "Classical", "Electronic", "Hip Hop", "Country", 
    "Blues", "Folk", "R&B", "Metal", "Punk", "Reggae", "World Music", "Soundtrack"
  ]
  
  music_genres.each do |genre_name|
    genre = Genre.find_or_create_by(name: genre_name, collection_type: music_collection) do |g|
      g.description = "#{genre_name} music"
    end
    
    if genre.persisted?
      puts "✓ Music genre '#{genre.name}' created/updated"
    else
      puts "✗ Failed to create music genre '#{genre_name}': #{genre.errors.full_messages.join(', ')}"
    end
  end
end

if series_collection
  series_genres = [
    "Drama", "Comedy", "Action", "Thriller", "Horror", "Sci-Fi", "Fantasy", 
    "Romance", "Crime", "Mystery", "Adventure", "Documentary", "Animation", 
    "Reality TV", "News", "Talk Show", "Game Show", "Soap Opera"
  ]
  
  series_genres.each do |genre_name|
    genre = Genre.find_or_create_by(name: genre_name, collection_type: series_collection) do |g|
      g.description = "#{genre_name} series and movies"
    end
    
    if genre.persisted?
      puts "✓ Series genre '#{genre.name}' created/updated"
    else
      puts "✗ Failed to create series genre '#{genre_name}': #{genre.errors.full_messages.join(', ')}"
    end
  end
end

puts "Genres seeding completed!" 