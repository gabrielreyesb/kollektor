import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchField", "results", "yearField", "preview", "container"]

  // Original direct album search
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
          const releases = data.releases.filter(r => r.date)
          if (releases.length > 0) {
            releases.sort((a, b) => new Date(a.date) - new Date(b.date))
            const originalRelease = releases[0]
            
            if (originalRelease.date) {
              const year = originalRelease.date.split('-')[0]
              this.yearFieldTarget.value = year
            }

            if (data.releases[0].id) {
              console.log('Attempting to fetch cover for release:', data.releases[0].id);
              this.fetchCover(data.releases[0].id)
            }
          }
        } else {
          this.resultsTarget.innerHTML = '<div class="alert alert-warning">No exact match found</div>'
        }
      })
      .catch(error => {
        console.error('Error:', error)
        this.resultsTarget.innerHTML = '<div class="alert alert-danger">Error searching album</div>'
      })
      .finally(() => {
        button.disabled = false
        button.innerHTML = '<i class="bi bi-search me-1"></i>Search Info'
      })
  }

  // Browse albums by artist
  searchAlbums(event) {
    const button = event.currentTarget
    const artistSelect = document.getElementById('album_author_id')
    const artistName = artistSelect.options[artistSelect.selectedIndex].text

    if (!artistName || artistSelect.value === "") {
      alert('Please select an artist first')
      return
    }

    button.disabled = true
    button.innerHTML = '<i class="bi bi-hourglass-split me-1"></i>Searching...'

    const url = `/api/musicbrainz/search?artist=${encodeURIComponent(artistName)}&browse=true`

    fetch(url)
      .then(response => {
        return response.json()
      })
      .then(data => {
        if (data.releases) {
          this.resultsTarget.innerHTML = this.renderResults(data.releases)
        } else {
          this.resultsTarget.innerHTML = '<div class="alert alert-warning">No results found</div>'
        }
      })
      .catch(error => {
        console.error('Error:', error)
        this.resultsTarget.innerHTML = '<div class="alert alert-danger">Error searching albums</div>'
      })
      .finally(() => {
        button.disabled = false
        button.innerHTML = '<i class="bi bi-collection me-1"></i>Browse Albums'
      })
  }

  selectAlbum(event) {
    event.preventDefault()
    const albumName = event.target.textContent.trim()
    this.searchFieldTarget.value = albumName
    this.resultsTarget.innerHTML = ''
    
    // Find and click the Search Info button
    const searchButton = this.element.querySelector('button[data-action="click->musicbrainz#search"]')
    if (searchButton) {
      searchButton.click()
    }
  }

  fetchCover(releaseId) {
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
        const imagePreview = document.getElementById('coverPreview')
        if (imagePreview) {
          imagePreview.src = imageUrl
          imagePreview.style.display = 'block'
        }
      })
      .catch(error => {
        console.error('Error fetching cover:', error)
        alert('Could not fetch album cover')
      })
  }

  renderResults(releases) {
    if (!releases.length) {
      return '<div class="alert alert-info">No albums found for this artist</div>'
    }

    // Remove duplicates by title
    const uniqueReleases = releases.reduce((acc, current) => {
      const x = acc.find(item => item.title === current.title);
      if (!x) {
        return acc.concat([{
          id: current.id,
          title: current.title
        }]);
      } else {
        return acc;
      }
    }, []);

    // Sort alphabetically
    uniqueReleases.sort((a, b) => a.title.localeCompare(b.title));

    const items = uniqueReleases.map(release => `
      <button type="button" 
              class="list-group-item list-group-item-action"
              data-action="click->musicbrainz#selectAlbum"
              data-musicbrainz-title-param="${release.title}">
        <div class="d-flex w-100">
          <h6 class="mb-0">${release.title}</h6>
        </div>
      </button>
    `).join('')

    return `<div class="list-group" style="max-height: 400px; overflow-y: auto;">${items}</div>`
  }
} 