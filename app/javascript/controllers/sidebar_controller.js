import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar"]

  connect() {
    this.handleResize = this.handleResize.bind(this)
    this.handleClickOutside = this.handleClickOutside.bind(this)
    
    window.addEventListener('resize', this.handleResize)
    document.addEventListener('click', this.handleClickOutside)
    
    this.handleResize()
  }

  disconnect() {
    window.removeEventListener('resize', this.handleResize)
    document.removeEventListener('click', this.handleClickOutside)
  }

  handleResize() {
    if (window.innerWidth <= 768) {
      this.sidebarTarget.classList.remove('active')
    }
  }

  handleClickOutside(event) {
    if (window.innerWidth <= 768 && 
        !this.sidebarTarget.contains(event.target) && 
        !event.target.closest('#sidebarToggle')) {
      this.sidebarTarget.classList.remove('active')
    }
  }

  toggle(event) {
    event.stopPropagation()
    this.sidebarTarget.classList.toggle('active')
  }
} 