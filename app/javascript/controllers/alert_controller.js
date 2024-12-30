import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    dismissAfter: Number
  }

  connect() {
    if (this.dismissAfterValue) {
      setTimeout(() => {
        this.element.classList.remove('show')
        setTimeout(() => {
          this.element.remove()
        }, 150)
      }, this.dismissAfterValue)
    }
  }
} 