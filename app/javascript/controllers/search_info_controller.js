import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["name", "searchResults", "searchButton"]

  connect() {
    console.log("Search info controller connected")
  }

  selectAlbum(event) {
    event.preventDefault()
    const albumName = event.target.textContent
    this.nameTarget.value = albumName
    this.searchResultsTarget.innerHTML = ''
    
    // Trigger click on the search button
    this.searchButtonTarget.click()
  }

  async searchReleaseInfo(albumName) {
    try {
      const response = await fetch(`/api/musicbrainz/release/${encodeURIComponent(albumName)}`)
      const data = await response.json()
      
      if (data.artist) {
        document.getElementById('album_author_attributes_name').value = data.artist
      }
      if (data.year) {
        document.getElementById('album_year').value = data.year
      }
      if (data.genre) {
        document.getElementById('album_genre_id').value = data.genre
      }
      if (data.cover_url) {
        // Handle cover image if needed
      }
    } catch (error) {
      console.error('Error fetching release info:', error)
    }
  }

  // ... rest of your controller code ...
} 