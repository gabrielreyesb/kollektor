import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["info"]

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