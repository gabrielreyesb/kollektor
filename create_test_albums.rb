#!/usr/bin/env ruby

# Script para crear 100 álbumes de prueba
# Ejecutar con: rails runner create_test_albums.rb

puts "=== CREANDO 100 ÁLBUMES DE PRUEBA ==="
puts "Fecha: #{Time.current}"
puts

# Obtener usuario y datos necesarios
user = User.first
unless user
  puts "❌ No hay usuarios en el sistema"
  exit 1
end

genres = Genre.all
authors = Author.all

if genres.empty? || authors.empty?
  puts "❌ Necesitas géneros y autores para crear álbumes"
  exit 1
end

puts "👤 Usuario: #{user.email}"
puts "🎵 Géneros disponibles: #{genres.count}"
puts "👨‍🎤 Autores disponibles: #{authors.count}"
puts

# Datos de prueba
album_names = [
  "Midnight Dreams", "Electric Storm", "Silent Echo", "Golden Horizon", "Crystal Clear",
  "Ocean Waves", "Mountain Peak", "Desert Wind", "Forest Path", "City Lights",
  "Starlight Symphony", "Moonlight Sonata", "Sunset Boulevard", "Rainbow Bridge", "Thunder Road",
  "Velvet Sky", "Emerald City", "Ruby Heart", "Sapphire Soul", "Diamond Mind",
  "Cosmic Journey", "Galactic Dreams", "Solar Flare", "Lunar Eclipse", "Stellar Wind",
  "Neon Nights", "Digital Dawn", "Analog Sunset", "Virtual Reality", "Cyber Dreams",
  "Jazz Fusion", "Rock Revolution", "Pop Paradise", "Classical Collection", "Blues Brothers",
  "Metal Masters", "Folk Tales", "Country Roads", "Hip Hop Heaven", "Electronic Empire",
  "Progressive Path", "Alternative Avenue", "Indie Island", "Punk Paradise", "Reggae Rhythm",
  "Soul Symphony", "Funk Factory", "Disco Dreams", "Techno Temple", "Ambient Air",
  "Chill Vibes", "Acoustic Dreams", "Symphonic Storm", "Orchestral Odyssey", "Chamber Music",
  "String Quartet", "Wind Ensemble", "Brass Band", "Percussion Paradise", "Vocal Harmony",
  "Guitar Glory", "Piano Poetry", "Bass Boost", "Drum Dynasty", "Keyboard Kingdom",
  "Synthesizer Symphony", "Sampler Stories", "Sequencer Soul", "Mixer Magic", "Producer Paradise",
  "Studio Sessions", "Live Legends", "Concert Classics", "Festival Fever", "Club Culture",
  "Underground Union", "Mainstream Magic", "Independent Spirit", "Major Label", "DIY Dreams",
  "Home Recording", "Garage Band", "Basement Sessions", "Attic Acoustics", "Loft Legends",
  "Warehouse Warriors", "Factory Floor", "Industrial Dreams", "Post-Punk Paradise", "New Wave",
  "Synthwave", "Retrowave", "Future Funk", "Vaporwave", "Lo-Fi Dreams",
  "High Fidelity", "Audiophile Heaven", "Vinyl Vibes", "Cassette Culture", "CD Classics",
  "Digital Dreams", "Streaming Stories", "Download Dynasty", "Playlist Paradise", "Mixtape Magic"
]

# Crear álbumes
puts "🔄 Creando 100 álbumes de prueba..."

created_count = 0
existing_count = user.albums.count

100.times do |i|
  album = user.albums.create!(
    name: album_names[i % album_names.length],
    year: 1970 + (i % 55), # Años entre 1970-2024
    genre: genres.sample,
    author: authors.sample
  )
  
  created_count += 1
  
  # Mostrar progreso cada 10 álbumes
  if (i + 1) % 10 == 0
    puts "   ✅ Creados #{i + 1} álbumes..."
  end
end

puts
puts "📊 RESUMEN:"
puts "   Álbumes existentes: #{existing_count}"
puts "   Álbumes creados: #{created_count}"
puts "   Total después: #{user.albums.count}"
puts
puts "🎯 Ahora puedes probar el scroll infinito con #{user.albums.count} álbumes!"
puts "   - Carga inicial: 20 álbumes"
puts "   - Scroll infinito: 20 álbumes por carga"
puts "   - Total de páginas: #{(user.albums.count.to_f / 20).ceil}"
puts
puts "=== FIN ===" 