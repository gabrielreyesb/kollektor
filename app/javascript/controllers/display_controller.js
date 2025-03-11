import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["info"]
  
  initialize() {
    // Bind the method to maintain the correct 'this' context
    this.debouncedResize = this.debounce(this.checkMobileView.bind(this), 100)
  }

  connect() {
    // Get saved preference from localStorage
    const showInfo = localStorage.getItem('showCardInfo') === 'true'
    this.element.checked = showInfo
    
    // Apply initial display settings
    this.updateDisplay(showInfo)
    
    // Set up resize listener with a debounced handler
    window.addEventListener('resize', this.debouncedResize)
    
    // Initial check
    this.checkMobileView()
  }
  
  disconnect() {
    // Clean up event listener when controller disconnects
    window.removeEventListener('resize', this.debouncedResize)
  }

  toggle(event) {
    const showInfo = event.target.checked
    localStorage.setItem('showCardInfo', showInfo)
    this.updateDisplay(showInfo)
  }

  updateDisplay(show) {
    // Don't override the display on mobile
    if (window.innerWidth >= 768) {
      document.querySelectorAll('.card-info').forEach(info => {
        info.style.display = show ? 'block' : 'none'
      })
    }
  }
  
  checkMobileView() {
    const isMobile = window.innerWidth < 768
    
    // Log for debugging
    console.log('Window width:', window.innerWidth, 'Is mobile:', isMobile)
    
    if (isMobile) {
      // Actively force card info to be visible on mobile
      document.querySelectorAll('.card-info').forEach(info => {
        info.style.display = 'block'
      })
      console.log('Mobile view activated - forced card info visible')
    } else {
      // Apply saved preferences on desktop
      this.updateDisplay(localStorage.getItem('showCardInfo') === 'true')
      console.log('Desktop view applied')
    }
  }
  
  // Helper function to debounce resize events
  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  }
} 