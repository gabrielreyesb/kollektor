import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.handleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener('click', this.handleClickOutside)
  }

  disconnect() {
    document.removeEventListener('click', this.handleClickOutside)
  }

  toggle(event) {
    event.stopPropagation()
    this.element.classList.toggle('active')
  }

  handleClickOutside(event) {
    if (window.innerWidth <= 768 && 
        !this.element.contains(event.target) && 
        !event.target.closest('.sidebar-toggle')) {
      this.element.classList.remove('active')
    }
  }
} 