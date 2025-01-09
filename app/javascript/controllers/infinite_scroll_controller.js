import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["entries", "pagination"]
  static values = { url: String }

  initialize() {
    this.intersectionObserver = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          this.loadMore()
        }
      })
    })
  }

  connect() {
    if (this.hasPaginationTarget) {
      this.intersectionObserver.observe(this.paginationTarget)
    }
  }

  disconnect() {
    this.intersectionObserver.disconnect()
  }

  loadMore() {
    const nextPage = this.paginationTarget.querySelector("a[rel='next']")
    if (!nextPage) return

    fetch(nextPage.href, {
      headers: { 
        Accept: "text/vnd.turbo-stream.html"
      }
    })
    .then(response => response.text())
    .then(html => {
      Turbo.renderStreamMessage(html)
    })
  }
} 