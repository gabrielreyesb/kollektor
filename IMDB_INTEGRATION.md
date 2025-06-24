# IMDB API Integration for Series Collection

This document explains how to set up and use the IMDB API integration for searching and fetching TV series data in your Kollektor application.

## Overview

The IMDB integration uses the **OMDB API** (Open Movie Database) to search for TV series and fetch their details, including posters. This allows users to easily find and add series to their collection with accurate information and cover images.

## Setup

### 1. Get an OMDB API Key

1. Visit [http://www.omdbapi.com/](http://www.omdbapi.com/)
2. Click on "API Key" in the navigation
3. Fill out the form to request a free API key
4. You'll receive your API key via email

### 2. Set Environment Variable

Add your API key to your environment variables:

```bash
# For development, add to your shell profile (.bashrc, .zshrc, etc.)
export OMDB_API_KEY='your_api_key_here'

# Or for Rails, add to config/application.rb or use a gem like dotenv
```

### 3. Test the Integration

Run the test script to validate your API key:

```bash
ruby test_imdb_api.rb
```

You should see output like:
```
Testing OMDB Search API...
✅ Search successful!
Found 10 results
First result: Breaking Bad (2008–2013)
IMDB ID: tt0903747
Poster: https://m.media-amazon.com/images/M/...

Testing OMDB Details API...
✅ Details fetch successful!
Title: Breaking Bad
Year: 2008–2013
Plot: A high school chemistry teacher turned methamphetamine manufacturer...
Genre: Crime, Drama, Thriller
Poster: https://m.media-amazon.com/images/M/...

🎉 IMDB API integration test completed successfully!
```

## Features

### 1. Series Search
- Search for TV series by name
- Real-time search results with debouncing
- Display series title, year, and poster thumbnail
- Filter results to show only TV series (not movies)

### 2. Series Details
- Fetch detailed information about selected series
- Get plot summary, genre, cast, and other metadata
- Extract year information (handles ranges like "2008–2013")

### 3. Poster Download
- Automatically download and attach series posters
- Handle cases where no poster is available
- Convert remote images to local file attachments

### 4. Form Population
- Auto-fill series name, description, and year
- Automatically attach the poster image
- Preserve user's ability to edit all fields

## Usage

### In the Series Form

1. Navigate to "Add New Series" or "Edit Series"
2. Use the "Search IMDB for Series" section at the top
3. Type a series name (e.g., "Breaking Bad", "Game of Thrones")
4. Select a series from the search results
5. The form will be automatically populated with:
   - Series name
   - Description (plot summary)
   - Year (first season year)
   - Cover image (poster)

### API Endpoints

The following API endpoints are available:

- `GET /api/imdb/search?query=series_name` - Search for series
- `GET /api/imdb/details/:imdb_id` - Get detailed series information
- `GET /api/imdb/poster/:imdb_id` - Get series poster URL

## Technical Details

### JavaScript Controller

The `imdb_controller.js` Stimulus controller handles:
- Debounced search input
- API communication
- Results display
- Form population
- Image download and attachment

### Rails Controller

The `Api::ImdbController` provides:
- Search endpoint using OMDB API
- Details endpoint for specific series
- Poster endpoint for image URLs
- Error handling and response formatting

### Error Handling

The integration includes comprehensive error handling:
- API key validation
- Network timeout handling
- Invalid response handling
- User-friendly error messages

## Limitations

1. **API Rate Limits**: OMDB API has rate limits for free accounts
2. **Image Availability**: Not all series have poster images available
3. **Data Accuracy**: Relies on OMDB/IMDB data accuracy
4. **Network Dependency**: Requires internet connection for searches

## Troubleshooting

### Common Issues

1. **"API key not found" error**
   - Ensure `OMDB_API_KEY` environment variable is set
   - Restart your Rails server after setting the variable

2. **"No results found"**
   - Check your search query spelling
   - Try different search terms
   - Verify the series exists on IMDB

3. **"Failed to download poster"**
   - Some series don't have poster images
   - Network connectivity issues
   - CORS restrictions (handled by proxy)

4. **Search not working**
   - Check browser console for JavaScript errors
   - Verify Stimulus controller is properly registered
   - Check network tab for API request failures

### Debug Mode

To enable debug logging, add to your browser console:
```javascript
localStorage.setItem('debug', 'imdb:*')
```

## Future Enhancements

Potential improvements for the IMDB integration:
- Cache search results to reduce API calls
- Add series ratings and reviews
- Include cast information from IMDB
- Support for movie searches (if needed)
- Batch import functionality
- Offline search history 