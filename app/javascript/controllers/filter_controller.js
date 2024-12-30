import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  change(event) {
    const value = event.target.value
    const type = event.target.dataset.filterTypeValue
    
    if (!value) {
      window.location.href = '/'
      return
    }
    
    window.location.href = `/?${type}=${value}`
  }
} 