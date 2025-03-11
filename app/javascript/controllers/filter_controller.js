import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    filterType: String
  }

  connect() {
    // Console log to verify the controller is connected
    console.log("Filter controller connected", this.filterTypeValue);
  }

  filterChanged(event) {    
    console.log("Filter changed", this.filterTypeValue, event.target.value);
    const value = event.target.value
    const type = this.filterTypeValue
    
    // Always start with the root path instead of current URL
    let url = new URL(window.location.origin)
    
    if (type === 'genre_id') {
      // Only set genre_id if it has a value
      if (value) {
        url.searchParams.set('genre_id', value)
      }
    } else if (type === 'author_id') {
      // Keep genre_id if it exists in the current URL
      const currentGenre = new URL(window.location).searchParams.get('genre_id')
      if (currentGenre) {
        url.searchParams.set('genre_id', currentGenre)
      }
      
      if (value) {
        url.searchParams.set('author_id', value)
      }
    } else if (type === 'album_id') {
      // Keep genre_id and author_id if they exist in the current URL
      const currentUrl = new URL(window.location)
      const currentGenre = currentUrl.searchParams.get('genre_id')
      const currentAuthor = currentUrl.searchParams.get('author_id')
      
      if (currentGenre) {
        url.searchParams.set('genre_id', currentGenre)
      }
      
      if (currentAuthor) {
        url.searchParams.set('author_id', currentAuthor)
      }
      
      if (value) {
        url.searchParams.set('album_id', value)
      }
    }
    
    // Log the URL we're about to navigate to
    console.log("Navigating to:", url.toString());
    
    // Force navigation to root path with filters
    window.location.href = url.toString();
  }
} 