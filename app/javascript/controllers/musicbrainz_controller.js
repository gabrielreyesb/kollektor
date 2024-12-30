import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["fetchButton", "yearField"]

  connect() {

  }

  async fetchInfo(event) {
    event.preventDefault()
    const button = event.currentTarget
    const albumName = document.getElementById('album_name').value
    const artistSelect = document.getElementById('album_author_id')
    const artistName = artistSelect.options[artistSelect.selectedIndex].text

    if (!albumName || !artistName) {
      alert('Please fill in both Album Name and Artist fields.')
      return
    }

    button.disabled = true
    button.innerHTML = '<i class="bi bi-hourglass-split me-1"></i>Searching...'

    try {
      // Search through our proxy
      const searchResponse = await fetch(`/api/musicbrainz/search?album=${encodeURIComponent(albumName)}&artist=${encodeURIComponent(artistName)}`)
      const searchData = await searchResponse.json()

      if (!searchData.releases || searchData.releases.length === 0) {
        throw new Error('No releases found for this album and artist.')
      }

      const releaseMbid = searchData.releases[0].id

      // Get release details through our proxy
      const releaseResponse = await fetch(`/api/musicbrainz/release/${releaseMbid}`)
      const releaseData = await releaseResponse.json()

      // Update year
      const releaseYear = releaseData['release-group']['first-release-date'].substring(0, 4)
      this.yearFieldTarget.value = releaseYear

      // Try to get cover art through our proxy
      try {
        const coverUrl = `/api/musicbrainz/cover/${releaseMbid}`
        const coverResponse = await fetch(coverUrl)
        
        if (coverResponse.ok) {
          const input = document.getElementById('album_cover_image')
          const imageBlob = await coverResponse.blob()
          
          // Resize image before creating File
          const resizedBlob = await this.resizeImage(imageBlob, 800) // 800px max width/height
          
          const file = new File([resizedBlob], 'cover.jpg', { type: 'image/jpeg' })
          
          const dataTransfer = new DataTransfer()
          dataTransfer.items.add(file)
          input.files = dataTransfer.files

          const preview = document.querySelector('.img-fluid.rounded')
          if (preview) {
            preview.style.display = 'block'
            preview.src = URL.createObjectURL(file)
          }
        }
      } catch (error) {
        console.log('Cover art not found')
      }

    } catch (error) {
      alert(error.message || 'Error fetching data from MusicBrainz')
    } finally {
      button.disabled = false
      button.innerHTML = '<i class="bi bi-search me-1"></i>Search Info'
    }
  }

  // Helper method to resize image
  async resizeImage(blob, maxSize) {
    return new Promise((resolve) => {
      const img = new Image()
      img.onload = () => {
        const canvas = document.createElement('canvas')
        let width = img.width
        let height = img.height

        // Calculate new dimensions
        if (width > height) {
          if (width > maxSize) {
            height = Math.round((height * maxSize) / width)
            width = maxSize
          }
        } else {
          if (height > maxSize) {
            width = Math.round((width * maxSize) / height)
            height = maxSize
          }
        }

        canvas.width = width
        canvas.height = height

        const ctx = canvas.getContext('2d')
        ctx.drawImage(img, 0, 0, width, height)

        // Convert to blob
        canvas.toBlob((blob) => {
          resolve(blob)
        }, 'image/jpeg', 0.85) // 0.85 is the quality (85%)
      }

      img.src = URL.createObjectURL(blob)
    })
  }
} 