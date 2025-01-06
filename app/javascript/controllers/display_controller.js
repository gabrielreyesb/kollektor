import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["info"]

  connect() {
    // Hide card info by default
    const cards = document.querySelectorAll('.card-info')
    cards.forEach(card => {
      card.style.display = 'none'
    })
  }

  toggle(event) {
    const showInfo = event.target.checked
    const cards = document.querySelectorAll('.card-info')
    
    cards.forEach(card => {
      if (showInfo) {
        card.style.display = 'block'
      } else {
        card.style.display = 'none'
      }
    })
  }
} 