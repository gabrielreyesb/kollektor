import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["pagination", "loading", "loadMoreButton"]
  
  connect() {
    this.createObserver()
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  createObserver() {
    this.observer = new IntersectionObserver(entries => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const button = entry.target.querySelector('[data-infinite-scroll-target="loadMoreButton"]')
          if (button) {
            button.click()
          }
        }
      })
    }, {
      rootMargin: '0px 0px 200px 0px',
      threshold: 0.1
    })

    if (this.hasPaginationTarget) {
      this.observer.observe(this.paginationTarget)
    }
  }
} 