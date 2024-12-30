import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Load saved preference
    const savedState = localStorage.getItem('show_card_info')
    if (savedState !== null) {
      this.element.querySelector('input').checked = savedState === 'true'
      this.updateDisplay(savedState === 'true')
    }
  }

  toggle(event) {
    const isChecked = event.target.checked
    this.updateDisplay(isChecked)
    // Save preference
    localStorage.setItem('show_card_info', isChecked)
  }

  updateDisplay(show) {
    const cards = document.querySelectorAll('.card')
    const cardInfos = document.querySelectorAll('.card-info')
    
    cardInfos.forEach(info => {
      info.style.display = show ? 'block' : 'none'
    })
    
    cards.forEach(card => {
      // When hiding info, remove the padding from card-body
      const cardBody = card.querySelector('.card-body')
      if (cardBody) {
        cardBody.style.padding = show ? '0.75rem' : '0'
      }
    })
  }
} 