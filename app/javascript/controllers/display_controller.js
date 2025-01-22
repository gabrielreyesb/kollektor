import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["info"]

  connect() {
    // Get saved preference from localStorage
    const showInfo = localStorage.getItem('showCardInfo') === 'true'
    this.element.checked = showInfo
    this.updateDisplay(showInfo)
  }

  toggle(event) {
    const showInfo = event.target.checked
    localStorage.setItem('showCardInfo', showInfo)
    this.updateDisplay(showInfo)
  }

  updateDisplay(show) {
    document.querySelectorAll('.card-info').forEach(info => {
      info.style.display = show ? 'block' : 'none'
    })
  }
} 