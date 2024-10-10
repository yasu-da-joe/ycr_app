import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "songsList", "songsCount"]

  connect() {
    console.log("Report controller connected");
    this.modal = null;
    
    // 残存するバックドロップを削除
    document.querySelectorAll('.modal-backdrop').forEach(backdrop => backdrop.remove());
    document.body.classList.remove('modal-open');
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
        const html = await response.text();
        const modalElement = document.getElementById('song-modal');
        modalElement.querySelector('.modal-content').innerHTML = html;
        
        // 既存のモーダルインスタンスがあれば破棄
        if (this.modal) {
          this.modal.dispose();
        }
        
        // 新しいモーダルインスタンスを作成
        this.modal = new bootstrap.Modal(modalElement, {
          backdrop: 'static',  // ユーザーが外側をクリックしてもモーダルが閉じないようにする
          keyboard: false  // Escキーでモーダルが閉じないようにする
        });
        
        this.modal.show();

        modalElement.addEventListener('hidden.bs.modal', this.handleModalHidden.bind(this));
      } else {
        console.error('Failed to load song form:', response.status, response.statusText);
      }
    } catch (error) {
      console.error('Error in addSong:', error)
    }
  }

  handleModalHidden() {
    this.closeModal()
  }

  async submitSong(event) {
    event.preventDefault()
    const form = event.target
    const formData = new FormData(form)
  
    try {
      const response = await fetch(form.action, {
        method: form.method,
        body: formData,
        headers: {
          'X-Requested-With': 'XMLHttpRequest',
          'Accept': 'application/json'
        }
      })
  
      const result = await response.json()
      if (result.success) {
        this.songsListTarget.insertAdjacentHTML('beforeend', result.html)
        this.updateSongsCount()
        this.closeModal()
        this.showFlashMessage(result.message, 'success')
      } else {
        this.showFlashMessage(result.errors.join(', '), 'error')
        // フォーム内のエラーメッセージを表示する処理をここに追加
      }
    } catch (error) {
      console.error('Error in submitSong:', error)
      this.showFlashMessage('予期せぬエラーが発生しました', 'error')
    }
  }

  closeModal() {
    console.log('closeModal called');
    // すべてのモーダルバックドロップを削除
    document.querySelectorAll('.modal-backdrop').forEach(backdrop => {
      console.log('Removing backdrop:', backdrop);
      backdrop.remove();
    });
  
    const modalElement = document.getElementById('song-modal');
    console.log('Modal element:', modalElement);
    if (modalElement) {
      const modalInstance = bootstrap.Modal.getInstance(modalElement);
      console.log('Modal instance:', modalInstance);
      if (modalInstance) {
        modalInstance.hide();
        modalInstance.dispose();
        console.log('Modal hidden and disposed');
      }
      modalElement.querySelector('.modal-content').innerHTML = '';
    }
  
    document.body.classList.remove('modal-open');
    console.log('modal-open class removed from body');
    this.modal = null;
    console.log('this.modal set to null');
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