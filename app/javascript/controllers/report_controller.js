import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "songsList"]

  connect() {
    console.log("Report controller connected")
    this.modal = null
  }

  async addSong(event) {
    try {
      event.preventDefault()
    
      if (!this.formTarget.dataset.reportId) {
        await this.initializeReport()
      }
    
      const reportId = this.formTarget.dataset.reportId
      if (!reportId) {
        console.error('Failed to initialize report')
        return
      }
    
      const response = await fetch(`/reports/${reportId}/add_song`, {
        method: 'GET',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        }
      })
    
      if (response.ok) {
        const html = await response.text()
        const modalElement = document.getElementById('song-modal')
        modalElement.querySelector('.modal-content').innerHTML = html
        this.modal = new bootstrap.Modal(modalElement)
        this.modal.show()

        modalElement.addEventListener('hidden.bs.modal', this.handleModalHidden.bind(this))
      } else {
        console.error('Failed to load song form:', response.status, response.statusText)
      }
    } catch (error) {
      console.error('Error in addSong:', error)
    }
  }

  handleModalHidden() {
    if (this.modal) {
      this.modal.dispose()
      this.modal = null
    }
    document.body.classList.remove('modal-open')
    document.querySelector('.modal-backdrop')?.remove()
  }

  async submitSong(event) {
    event.preventDefault()
    const form = event.target
    const formData = new FormData(form)
  
    const response = await fetch(form.action, {
      method: form.method,
      body: formData,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Accept': 'application/json'
      }
    })

    if (response.ok) {
      const result = await response.json()
      if (result.success) {
        this.songsListTarget.insertAdjacentHTML('beforeend', result.html)
        this.closeModal()
      } else {
        console.error('Failed to add song:', result.errors)
        // エラーメッセージを表示するロジックをここに追加
      }
    } else {
      console.error('Failed to submit song form')
      // エラーメッセージを表示するロジックをここに追加
    }
  }

  closeModal() {
    if (this.modal) {
      this.modal.hide()
    }
  }

  async submitSong(event) {
    event.preventDefault()
    const form = event.target
    const formData = new FormData(form)
  
    const response = await fetch(form.action, {
      method: form.method,
      body: formData,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Accept': 'application/json'
      }
    })

    if (response.ok) {
      const result = await response.json()
      if (result.success) {
        this.songsListTarget.insertAdjacentHTML('beforeend', result.html)
        bootstrap.Modal.getInstance(document.getElementById('song-modal')).hide()
      } else {
        console.error('Failed to add song:', result.errors)
        // エラーメッセージを表示するロジックをここに追加
      }
    } else {
      console.error('Failed to submit song form')
      // エラーメッセージを表示するロジックをここに追加
    }
  }

  async initializeReport() {
    try {
      const response = await fetch('/reports/initialize_report', {
        method: 'POST',
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        }
      });
  
      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(errorData.error || `HTTP error! status: ${response.status}`);
      }
  
      const result = await response.json();
      this.formTarget.dataset.reportId = result.report_id;
      return result.report_id;
    } catch (error) {
      console.error('Failed to initialize report:', error.message);
      // ここでユーザーにエラーを通知することもできます
      return null;
    }
  }

  async saveDraft(event) {
    event.preventDefault()
    await this.saveReport('draft')
  }

  async publish(event) {
    event.preventDefault()
    await this.saveReport('publish')
  }

  async saveReport(action) {
    const formData = new FormData(this.formTarget)
    formData.append(action, true)

    const response = await fetch(this.formTarget.action, {
      method: this.formTarget.method,
      body: formData,
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Accept': 'application/json'
      }
    })

    if (response.ok) {
      const result = await response.json()
      if (result.success) {
        window.location.href = result.redirect_url
      } else {
        console.error('Failed to save report:', result.errors)
        // エラーメッセージを表示するロジックをここに追加
      }
    } else {
      console.error('Failed to submit report form')
      // エラーメッセージを表示するロジックをここに追加
    }
  }

  removeSong(event) {
    const songItem = event.target.closest('.song-item')
    if (songItem) {
      songItem.remove()
    }
  }
}