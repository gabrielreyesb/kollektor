import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]

  search() {
    const query = this.inputTarget.value
    const url = this.element.dataset.searchUrl

    fetch(`${url}?query=${encodeURIComponent(query)}`, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    .then(response => response.text())
    .then(html => {
      this.resultsTarget.innerHTML = html
    })
  }
}