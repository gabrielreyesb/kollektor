import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "recommendationsContainer"]

  connect() {
    // Only auto-show for daily prompt
    if (this.element.dataset.showPrompt === 'true') {
      this.showModal()
    }
  }

  showModal() {
    const modal = new bootstrap.Modal(document.querySelector('[data-mood-prompt-target="modal"]'))
    modal.show()
  }

  async selectGenre(event) {
    const genreId = event.target.value
    if (!genreId) return

    try {
      const response = await fetch(`/api/recommendations/by_genre/${genreId}`)
      const html = await response.text()
      this.recommendationsContainerTarget.innerHTML = html
    } catch (error) {
      console.error('Error fetching recommendations:', error)
    }
  }
} 