import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    filterType: String
  }

  connect() {
  }

  filterChanged(event) {    
    const value = event.target.value
    const type = this.filterTypeValue
    let url = new URL(window.location)
    
    if (type === 'genre_id') {
      // Clear everything when genre changes
      url.searchParams.delete('genre_id')
      url.searchParams.delete('author_id')
      url.searchParams.delete('album_id')
      if (value) {
        url.searchParams.set('genre_id', value)
      }
    } else {
      // Keep genre_id when changing author or album
      const currentGenre = url.searchParams.get('genre_id')
      url.searchParams.delete('author_id')
      url.searchParams.delete('album_id')
      if (currentGenre) {
        url.searchParams.set('genre_id', currentGenre)
      }
      if (value) {
        url.searchParams.set(type, value)
      }
    }
    
    window.location = url.toString()
  }
} 