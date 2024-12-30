import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["authorSelect"]

  async filterAuthors(event) {
    const genreId = event.target.value
    const authorSelect = this.authorSelectTarget
    
    // Clear current selection
    authorSelect.value = ""
    
    if (!genreId) {
      // If no genre selected, fetch all authors
      const response = await fetch('/api/authors')
      const authors = await response.json()
      this.updateAuthors(authors)
    } else {
      // Fetch authors for selected genre
      const response = await fetch(`/api/authors?genre_id=${genreId}`)
      const authors = await response.json()
      this.updateAuthors(authors)
    }
  }

  updateAuthors(authors) {
    const authorSelect = this.authorSelectTarget
    
    // Keep the prompt option
    const promptOption = authorSelect.querySelector('option[value=""]')
    authorSelect.innerHTML = ''
    if (promptOption) {
      authorSelect.appendChild(promptOption)
    }
    
    // Add filtered authors
    authors.forEach(author => {
      const option = new Option(author.name, author.id)
      authorSelect.appendChild(option)
    })
  }
} 