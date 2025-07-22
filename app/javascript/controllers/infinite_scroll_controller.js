import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger"]
  static values = { 
    page: { type: Number, default: 1 },
    loading: { type: Boolean, default: false },
    hasMore: { type: Boolean, default: true }
  }

  connect() {
    this.observer = new IntersectionObserver(
      (entries) => {
        entries.forEach(entry => {
          if (entry.isIntersecting && this.hasMoreValue && !this.loadingValue) {
            this.loadMore()
          }
        })
      },
      { threshold: 0.1 }
    )

    if (this.hasTriggerTarget) {
      this.observer.observe(this.triggerTarget)
    }
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  async loadMore() {
    if (this.loadingValue || !this.hasMoreValue) return

    this.loadingValue = true
    this.showLoading()

    try {
      const nextPage = this.pageValue + 1
      const url = new URL(window.location)
      url.searchParams.set('page', nextPage)

      const response = await fetch(url, {
        headers: {
          'Accept': 'text/vnd.turbo-stream.html',
          'X-Requested-With': 'XMLHttpRequest'
        }
      })

      if (response.ok) {
        const html = await response.text()
        
        // Parse Turbo Stream response
        const parser = new DOMParser()
        const doc = parser.parseFromString(html, 'text/html')
        const turboStream = doc.querySelector('turbo-stream')
        
        if (turboStream) {
          const action = turboStream.getAttribute('action')
          const target = turboStream.getAttribute('target')
          
          if (action === 'append' && target === 'albums-grid') {
            const content = turboStream.innerHTML
            const targetElement = document.getElementById(target)
            
            if (targetElement) {
              targetElement.insertAdjacentHTML('beforeend', content)
              this.pageValue = nextPage
              
              // Check if there are more albums to load
              const newAlbums = targetElement.querySelectorAll('.col-6')
              if (newAlbums.length < 20) {
                this.hasMoreValue = false
                this.hideTrigger()
              }
            }
          }
        }
      }
    } catch (error) {
      console.error('Error loading more albums:', error)
    } finally {
      this.loadingValue = false
      this.hideLoading()
    }
  }

  showLoading() {
    if (this.hasTriggerTarget) {
      const spinner = this.triggerTarget.querySelector('.spinner-border')
      if (spinner) {
        spinner.style.display = 'inline-block'
      }
    }
  }

  hideLoading() {
    if (this.hasTriggerTarget) {
      const spinner = this.triggerTarget.querySelector('.spinner-border')
      if (spinner) {
        spinner.style.display = 'none'
      }
    }
  }

  hideTrigger() {
    if (this.hasTriggerTarget) {
      this.triggerTarget.style.display = 'none'
    }
  }
} 