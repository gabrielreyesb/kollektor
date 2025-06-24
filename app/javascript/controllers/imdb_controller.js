import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "results", "form", "nameInput", "descriptionInput", "yearInput", "coverImageInput", "posterPreview"]
  static values = { 
    searchUrl: String,
    detailsUrl: String
  }

  connect() {
    this.searchUrl = this.searchUrlValue || '/api/imdb/search'
    this.detailsUrl = this.detailsUrlValue || '/api/imdb/details'
    // Listen for manual file selection to update preview
    if (this.hasCoverImageInputTarget) {
      this.coverImageInputTarget.addEventListener('change', (e) => this.updatePosterPreviewFromFile())
    }
  }

  // Debounced search to avoid too many API calls
  async search() {
    const query = this.searchInputTarget.value.trim()
    
    if (query.length < 2) {
      this.clearResults()
      return
    }

    try {
      this.showLoading()
      
      const response = await fetch(`${this.searchUrl}?query=${encodeURIComponent(query)}`)
      const data = await response.json()

      if (data.success) {
        this.displayResults(data.results)
      } else {
        this.showError(data.error || 'Failed to search for series or movies')
      }
    } catch (error) {
      console.error('Search error:', error)
      this.showError('Failed to search for series or movies')
    }
  }

  displayResults(results) {
    this.resultsTarget.innerHTML = results.map(series => `
      <div class="imdb-result card mb-2" data-imdb-id="${series.imdbID}">
        <div class="card-body d-flex align-items-center">
          <div class="flex-shrink-0 me-3">
            <img src="${this.getPosterUrl(series.Poster)}" 
                 alt="${series.Title}" 
                 class="img-thumbnail" 
                 style="width: 60px; height: 90px; object-fit: cover;"
                 onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iOTAiIHZpZXdCb3g9IjAgMCA2MCA5MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjYwIiBoZWlnaHQ9IjkwIiBmaWxsPSIjNjc3NDhCIi8+CjxwYXRoIGQ9Ik0yMCAyNUg0MFY2NUgyMFYyNVoiIGZpbGw9IiM0OTUwNTciLz4KPHBhdGggZD0iTTE1IDMwTDI1IDQwTDE1IDUwVjMwWiIgZmlsbD0iIzQ5NTA1NyIvPgo8cGF0aCBkPSJNNDUgMzBMNTUgNDBMNDUgNTBWMzBaIiBmaWxsPSIjNDk1MDU3Ii8+Cjwvc3ZnPgo='">
          </div>
          <div class="flex-grow-1">
            <h6 class="card-title mb-1">${series.Title}</h6>
            <p class="card-text text-muted mb-1">${series.Year}</p>
            <p class="card-text small text-muted">${series.Type}</p>
          </div>
          <div class="flex-shrink-0">
            <button type="button" 
                    class="btn btn-sm btn-primary" 
                    data-action="click->imdb#selectSeries" 
                    data-imdb-id="${series.imdbID}">
              Select
            </button>
          </div>
        </div>
      </div>
    `).join('')
  }

  getPosterUrl(posterUrl) {
    // If no poster or N/A, return the default SVG
    if (!posterUrl || posterUrl === 'N/A') {
      return 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNjAiIGhlaWdodD0iOTAiIHZpZXdCb3g9IjAgMCA2MCA5MCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHJlY3Qgd2lkdGg9IjYwIiBoZWlnaHQ9IjkwIiBmaWxsPSIjNjc3NDhCIi8+CjxwYXRoIGQ9Ik0yMCAyNUg0MFY2NUgyMFYyNVoiIGZpbGw9IiM0OTUwNTciLz4KPHBhdGggZD0iTTE1IDMwTDI1IDQwTDE1IDUwVjMwWiIgZmlsbD0iIzQ5NTA1NyIvPgo8cGF0aCBkPSJNNDUgMzBMNTUgNDBMNDUgNTBWMzBaIiBmaWxsPSIjNDk1MDU3Ii8+Cjwvc3ZnPgo='
    }
    
    // Try to fix common IMDB URL issues
    let fixedUrl = posterUrl
    
    // Remove any query parameters that might cause issues
    if (fixedUrl.includes('?')) {
      fixedUrl = fixedUrl.split('?')[0]
    }
    
    // Ensure it's HTTPS
    if (fixedUrl.startsWith('http://')) {
      fixedUrl = fixedUrl.replace('http://', 'https://')
    }
    
    return fixedUrl
  }

  showNoResults(message) {
    this.resultsTarget.innerHTML = `
      <div class="alert alert-info">
        <i class="bi bi-info-circle"></i> ${message}
      </div>
    `
  }

  showError(message) {
    this.resultsTarget.innerHTML = `
      <div class="alert alert-danger">
        <i class="bi bi-exclamation-triangle me-2"></i>
        ${message}
      </div>
    `
  }

  showLoading() {
    this.resultsTarget.innerHTML = `
      <div class="text-center py-3">
        <div class="spinner-border spinner-border-sm me-2" role="status">
          <span class="visually-hidden">Loading...</span>
        </div>
        <p class="mt-2">Searching for series or movies...</p>
      </div>
    `
  }

  clearResults() {
    this.resultsTarget.innerHTML = ''
  }

  async selectSeries(event) {
    const imdbId = event.currentTarget.dataset.imdbId
    
    try {
      this.showLoading()
      
      const response = await fetch(`${this.detailsUrl}/${imdbId}`)
      const data = await response.json()

      if (data.success) {
        this.populateForm(data.series)
        this.clearResults()
        this.searchInputTarget.value = data.series.Title
      } else {
        this.showError(data.error || 'Failed to get series or movie details')
      }
    } catch (error) {
      console.error('Details error:', error)
      this.showError('Failed to get series or movie details')
    }
  }

  populateForm(series) {
    // Populate form fields with series data
    if (this.hasNameInputTarget) {
      this.nameInputTarget.value = series.Title
    }
    
    if (this.hasDescriptionInputTarget) {
      this.descriptionInputTarget.value = series.Plot || ''
    }
    
    if (this.hasYearInputTarget) {
      // Extract year from Year field (format: "2010–2015" or "2010")
      const year = series.Year ? series.Year.split('–')[0] : ''
      this.yearInputTarget.value = year
    }

    // Try to match genre
    if (series.Genre) {
      const firstGenre = series.Genre.split(',')[0].trim().toLowerCase();
      const genreSelect = document.querySelector('select[name="series[genre_id]"]');
      
      if (genreSelect) {
        const options = Array.from(genreSelect.options);
        const matchingOption = options.find(option => 
          option.text.toLowerCase().includes(firstGenre)
        );
        
        if (matchingOption) {
          genreSelect.value = matchingOption.value;
        }
      }
    }

    // Only try to download poster if it's a valid URL
    if (series.Poster && series.Poster !== 'N/A' && this.hasCoverImageInputTarget) {
      // Check if the poster URL is valid before attempting download
      if (this.isValidPosterUrl(series.Poster)) {
        this.downloadAndAttachPoster(series.Poster)
      }
    }
  }

  isValidPosterUrl(url) {
    // Basic validation for IMDB poster URLs
    return url && 
           url !== 'N/A' && 
           (url.includes('imdb.com') || url.includes('media-amazon.com')) &&
           url.match(/\.(jpg|jpeg|png|webp)$/i)
  }

  async downloadAndAttachPoster(posterUrl) {
    try {
      const fixedUrl = this.getPosterUrl(posterUrl)
      
      // Skip if it's the default SVG
      if (fixedUrl.startsWith('data:image/svg+xml')) {
        return
      }
      
      // Use the backend proxy to avoid CORS issues
      const proxyUrl = `/api/imdb/poster_proxy?url=${encodeURIComponent(fixedUrl)}`
      
      const response = await fetch(proxyUrl, {
        method: 'GET',
        headers: {
          'Accept': 'image/*'
        }
      })
      
      if (!response.ok) {
        console.warn('Failed to download poster via proxy:', response.status, response.statusText)
        return
      }
      
      const blob = await response.blob()
      
      // Verify it's actually an image
      if (!blob.type.startsWith('image/')) {
        console.warn('Downloaded content is not an image:', blob.type)
        return
      }
      
      const file = new File([blob], 'series_or_movie_poster.jpg', { type: blob.type })
      
      // Create a new FileList-like object
      const dataTransfer = new DataTransfer()
      dataTransfer.items.add(file)
      
      this.coverImageInputTarget.files = dataTransfer.files
      
      // Show preview
      if (this.hasPosterPreviewTarget) {
        this.posterPreviewTarget.src = URL.createObjectURL(blob)
        this.posterPreviewTarget.style.display = 'block'
      }
    } catch (error) {
      console.error('Error downloading poster:', error)
      // Don't show error to user, just log it
    }
  }

  updatePosterPreviewFromFile() {
    if (this.hasPosterPreviewTarget && this.coverImageInputTarget.files && this.coverImageInputTarget.files[0]) {
      const file = this.coverImageInputTarget.files[0]
      const url = URL.createObjectURL(file)
      this.posterPreviewTarget.src = url
      this.posterPreviewTarget.style.display = 'block'
    }
  }
} 