import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    const sidebar = this.element
    sidebar.classList.toggle('active')
  }
} 