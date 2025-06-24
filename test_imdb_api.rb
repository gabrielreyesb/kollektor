#!/usr/bin/env ruby

require 'httparty'
require 'json'

# Test script to validate IMDB API integration
# This script tests the OMDB API endpoints that we'll use in our Rails app

def test_omdb_search
  puts "Testing OMDB Search API..."
  
  # You'll need to get a free API key from http://www.omdbapi.com/
  api_key = ENV['OMDB_API_KEY']
  
  if api_key.nil?
    puts "❌ OMDB_API_KEY environment variable not set!"
    puts "Please get a free API key from http://www.omdbapi.com/"
    puts "Then set it as: export OMDB_API_KEY='your_api_key_here'"
    return false
  end
  
  # Test search for a popular TV series
  search_query = "Breaking Bad"
  
  begin
    response = HTTParty.get(
      "http://www.omdbapi.com/",
      query: {
        s: search_query,
        type: "series",
        apikey: api_key
      },
      timeout: 10
    )
    
    if response.success?
      data = JSON.parse(response.body)
      
      if data["Response"] == "True"
        puts "✅ Search successful!"
        puts "Found #{data['totalResults']} results"
        
        if data["Search"] && data["Search"].any?
          first_result = data["Search"].first
          puts "First result: #{first_result['Title']} (#{first_result['Year']})"
          puts "IMDB ID: #{first_result['imdbID']}"
          puts "Poster: #{first_result['Poster']}"
          
          # Test getting details for the first result
          test_omdb_details(first_result['imdbID'], api_key)
        end
      else
        puts "❌ Search failed: #{data['Error']}"
        return false
      end
    else
      puts "❌ HTTP request failed: #{response.code}"
      return false
    end
  rescue => e
    puts "❌ Error: #{e.message}"
    return false
  end
  
  true
end

def test_omdb_details(imdb_id, api_key)
  puts "\nTesting OMDB Details API..."
  
  begin
    response = HTTParty.get(
      "http://www.omdbapi.com/",
      query: {
        i: imdb_id,
        apikey: api_key
      },
      timeout: 10
    )
    
    if response.success?
      data = JSON.parse(response.body)
      
      if data["Response"] == "True"
        puts "✅ Details fetch successful!"
        puts "Title: #{data['Title']}"
        puts "Year: #{data['Year']}"
        puts "Plot: #{data['Plot'][0..100]}..." if data['Plot']
        puts "Genre: #{data['Genre']}"
        puts "Poster: #{data['Poster']}"
      else
        puts "❌ Details fetch failed: #{data['Error']}"
      end
    else
      puts "❌ HTTP request failed: #{response.code}"
    end
  rescue => e
    puts "❌ Error: #{e.message}"
  end
end

# Run the test
if test_omdb_search
  puts "\n🎉 IMDB API integration test completed successfully!"
  puts "You can now use the IMDB search functionality in your Rails app."
else
  puts "\n❌ IMDB API integration test failed!"
  puts "Please check your API key and try again."
end 