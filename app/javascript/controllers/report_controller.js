import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    console.log("Report controller connected")
    this.modal = new bootstrap.Modal(document.getElementById('song-modal'))
    document.getElementById('song-modal').addEventListener('hidden.bs.modal', this.handleModalHidden.bind(this))
  }

  addSong(event) {
    event.preventDefault()
    const reportId = this.formTarget.dataset.reportId
    
    fetch(`/reports/${reportId}/add_song`, {
      headers: {
        'Accept': 'text/html'
      }
    })
    .then(response => response.text())
    .then(html => {
      document.querySelector('#song-modal .modal-content').innerHTML = html
      this.modal.show()
    })
  }

  closeModal(event) {
    if (event) event.preventDefault()
    this.modal.hide()
  }

  removeBackdrop() {
    const backdrop = document.querySelector('.modal-backdrop')
    if (backdrop) {
      backdrop.remove()
    }
    document.body.classList.remove('modal-open')
    document.body.style.removeProperty('padding-right')
    document.body.style.removeProperty('overflow')
  }

  submitSong(event) {
    event.preventDefault()
    const form = event.target
    const formData = new FormData(form)

    fetch(form.action, {
      method: form.method,
      body: formData,
      headers: {
        'Accept': 'application/json'
      }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // 曲リストを更新
        const songsList = document.getElementById('songs-list')
        songsList.insertAdjacentHTML('beforeend', data.html)
        
        // 曲数を更新
        const songsCount = document.getElementById('songs-count')
        const currentCount = parseInt(songsCount.textContent.match(/\d+/)[0])
        songsCount.textContent = `曲数: ${currentCount + 1}`

        // モーダルを閉じる
        this.modal.hide()
        this.removeBackdrop()

        // フラッシュメッセージを表示
        const flashMessages = document.getElementById('flash-messages')
        flashMessages.innerHTML = '<div class="alert alert-success">曲が追加されました</div>'
      } else {
        // エラーメッセージを表示
        const errorContainer = form.querySelector('.error-messages')
        errorContainer.innerHTML = data.errors.map(error => `<p>${error}</p>`).join('')
      }
    })
  }

  handleModalHidden() {
    this.removeBackdrop()
  }

  updateSongsCount() {
    if (this.hassongsCountTarget) {
      const currentCount = this.songsListTarget.querySelectorAll('.song-item').length
      this.songsCountTarget.textContent = `曲数: ${currentCount}`
    }
  }

  showFlashMessage(message, type) {
    const flashContainer = document.getElementById('flash-messages')
    if (flashContainer) {
      const alertClass = type === 'success' ? 'alert-success' : 'alert-danger'
      const flashHtml = `
        <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
          ${message}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      `
      flashContainer.innerHTML = flashHtml
      setTimeout(() => {
        const alert = flashContainer.querySelector('.alert')
        if (alert) {
          alert.remove()
        }
      }, 3000)
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
      this.showFlashMessage('レポートの初期化に失敗しました', 'error');
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
        this.showFlashMessage('レポートの保存に失敗しました', 'error')
      }
    } else {
      console.error('Failed to submit report form')
      this.showFlashMessage('エラーが発生しました', 'error')
    }
  }

  removeSong(event) {
    const songItem = event.target.closest('.song-item')
    if (songItem) {
      songItem.remove()
      this.updateSongsCount()
      this.showFlashMessage('曲が削除されました', 'success')
    }
  }
}