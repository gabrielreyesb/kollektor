import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "recommendationsContainer", "genreSelect", "refreshButtonContainer"]

  connect() {
    this.modalTarget.addEventListener('show.bs.modal', this.clearRecommendations.bind(this))
  }

  clearRecommendations() {
    this.recommendationsContainerTarget.innerHTML = ''
    this.genreSelectTarget.value = ''
    this.refreshButtonContainerTarget.style.display = 'none'
  }

  async selectGenre(event) {
    const genreId = this.genreSelectTarget.value
    
    if (!genreId) {
      this.recommendationsContainerTarget.innerHTML = ''
      this.refreshButtonContainerTarget.style.display = 'none'
      return
    }

    await this.fetchRecommendations(genreId)
  }

  async refreshSuggestions() {
    const genreId = this.genreSelectTarget.value
    if (genreId) {
      await this.fetchRecommendations(genreId)
    }
  }

  async fetchRecommendations(genreId) {
    try {
      let url = `/api/recommendations/by_genre/`
      if (genreId === 'random') {
        url += 'random'
      } else {
        url += genreId
      }

      const response = await fetch(url)
      
      if (!response.ok) {
        throw new Error('Network response was not ok')
      }
      
      const html = await response.text()
      this.recommendationsContainerTarget.innerHTML = html
      this.refreshButtonContainerTarget.style.display = 'block'
    } catch (error) {
      this.recommendationsContainerTarget.innerHTML = `
        <div class="alert alert-danger">
          Error loading recommendations. Please try again.
          <br>
          <small class="text-muted">${error.message}</small>
        </div>
      `
      this.refreshButtonContainerTarget.style.display = 'none'
    }
  }
} 