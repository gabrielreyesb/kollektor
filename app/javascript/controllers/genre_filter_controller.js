import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["authorSelect"]

  filterAuthors(event) {
    const genreId = event.target.value
    const authors = this.authorSelectTarget
    
    // Store the current selection
    const currentAuthorId = authors.value

    // Reset the authors dropdown
    authors.innerHTML = '<option value="">Select an author</option>'
    
    if (genreId) {
      fetch(`/api/authors?genre_id=${genreId}`)
        .then(response => response.json())
        .then(data => {
          data.forEach(author => {
            const option = new Option(author.name, author.id)
            authors.add(option)
          })
          
          // Restore the previous selection if it exists in the new options
          if (currentAuthorId) {
            authors.value = currentAuthorId
          }
        })
    }
  }

  // Add this method to watch for author selection changes
  authorChanged() {
    const authorId = this.authorSelectTarget.value
    if (authorId) {
      // Find and click the Browse Albums button
      const browseButton = this.element.querySelector('button[data-action="click->musicbrainz#searchAlbums"]')
      if (browseButton) {
        browseButton.click()
      }
    }
  }
} 