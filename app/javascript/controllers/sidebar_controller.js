import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "overlay", "toggleButton"]

  connect() {
    this.updateSidebarState()
    this.handleResize = this.handleResize.bind(this)
    window.addEventListener('resize', this.handleResize)
    document.addEventListener('click', this.handleOutsideClick.bind(this))
  }

  disconnect() {
    window.removeEventListener('resize', this.handleResize)
    document.removeEventListener('click', this.handleOutsideClick)
  }

  toggle() {
    if (window.innerWidth < 768) {
      document.body.style.overflow = this.sidebarTarget.classList.contains('show') ? 'auto' : 'hidden'
      this.sidebarTarget.classList.toggle('show')
      this.overlayTarget.classList.toggle('show')
    } else {
      this.sidebarTarget.classList.toggle('collapsed')
      document.body.classList.toggle('sidebar-collapsed')
    }
  }

  handleResize() {
    this.updateSidebarState()
  }

  updateSidebarState() {
    if (window.innerWidth < 768) {
      this.sidebarTarget.classList.remove('collapsed')
      document.body.classList.remove('sidebar-collapsed')
      this.sidebarTarget.classList.remove('show')
      this.overlayTarget.classList.remove('show')
      document.body.style.overflow = 'auto'
    }
  }

  closeOnMobile() {
    if (window.innerWidth < 768) {
      this.sidebarTarget.classList.remove('show')
      this.overlayTarget.classList.remove('show')
    }
  }

  handleOutsideClick(event) {
    if (window.innerWidth < 768 && 
        !this.sidebarTarget.contains(event.target) && 
        !event.target.closest('[data-action="sidebar#toggle"]')) {
      this.sidebarTarget.classList.remove('show')
      this.overlayTarget.classList.remove('show')
      document.body.style.overflow = 'auto'
    }
  }
} 