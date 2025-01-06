import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchField", "results", "yearField"]

  search(event) {
    const button = event.currentTarget
    const albumName = this.searchFieldTarget.value
    const artistSelect = document.getElementById('album_author_id')
    const artistName = artistSelect.options[artistSelect.selectedIndex].text

    if (!albumName || !artistName) {
      alert('Please fill in both Album Name and Artist fields.')
      return
    }

    button.disabled = true
    button.innerHTML = '<i class="bi bi-hourglass-split me-1"></i>Searching...'

    fetch(`/api/musicbrainz/search?album=${encodeURIComponent(albumName)}&artist=${encodeURIComponent(artistName)}`)
      .then(response => response.json())
      .then(data => {
        if (data.releases && data.releases.length > 0) {
          // Try to find the earliest release
          const releases = data.releases.filter(r => r.date)  // Only releases with dates
          if (releases.length > 0) {
            // Sort by date and get the earliest
            releases.sort((a, b) => new Date(a.date) - new Date(b.date))
            const originalRelease = releases[0]
            
            // Update year field with the earliest release date
            if (originalRelease.date) {
              const year = originalRelease.date.split('-')[0]
              this.yearFieldTarget.value = year
            }

            // Use the first release ID for cover art (might want to match with the earliest release)
            if (data.releases[0].id) {
              this.fetchCoverArt(data.releases[0].id)
            }
          }
        } else {
          console.log('No releases found')
        }
      })
      .catch(error => {
        console.error('Error:', error)
        alert('Error searching for album')
      })
      .finally(() => {
        button.disabled = false
        button.innerHTML = '<i class="bi bi-search me-1"></i>Search Info'
      })
  }

  fetchCoverArt(releaseId) {
    fetch(`/api/musicbrainz/cover/${releaseId}`)
      .then(response => {
        if (!response.ok) throw new Error('Network response was not ok')
        return response.blob()
      })
      .then(blob => {
        // Create a File object from the blob
        const file = new File([blob], 'cover.jpg', { type: 'image/jpeg' })
        
        // Create a DataTransfer to create a FileList
        const dataTransfer = new DataTransfer()
        dataTransfer.items.add(file)
        
        // Find the file input and set its files
        const fileInput = document.querySelector('input[type="file"]')
        if (fileInput) {
          fileInput.files = dataTransfer.files
        }

        // Update preview
        const imageUrl = URL.createObjectURL(blob)
        const imagePreview = document.querySelector('img.img-fluid.rounded')
        if (imagePreview) {
          imagePreview.src = imageUrl
          imagePreview.style.display = 'block'
        }
      })
      .catch(error => console.error('Error fetching cover:', error))
  }
} 