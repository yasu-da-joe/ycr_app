console.log('=== report_controller.js loaded ===');
console.log('File load timestamp:', new Date().toISOString());

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]
  static values = { reportFormId: String }  // 追加

  initialize() {
    console.log("=== Report Controller Initialized ===");
  }

  connect() {
    console.log("Report controller connected");
    console.log("Form target:", this.formTarget);
    console.log("Report ID:", this.formTarget.dataset.reportId);
    this.initializeModal();
  }
  
  initializeModal() {
    console.log("=== Initializing Modal ===");
    this.modalElement = document.getElementById('song-modal');
    console.log("Modal element:", this.modalElement);
    
    if (this.modalElement) {
      try {
        console.log("Creating Bootstrap Modal instance");
        this.modal = new bootstrap.Modal(this.modalElement, { 
          backdrop: 'static', 
          keyboard: false 
        });
        console.log("Modal instance created:", this.modal);
      } catch (error) {
        console.error("Error creating modal:", error);
      }
    } else {
      console.warn("Modal element not found");
    }
  }

  openEditModal(event) {
    event.preventDefault();
    event.stopPropagation();
    
    console.log("=== Edit Modal Trigger ===");
    const link = event.currentTarget;
    const setListOrderId = link.dataset.setListOrderId;
    const reportId = link.dataset.reportId;
    const sectionId = link.dataset.sectionId;

    if (!reportId || !sectionId || !setListOrderId) {
      console.error('Required IDs are missing');
      return;
    }
    
    fetch(`/reports/${reportId}/sections/${sectionId}/set_list_orders/${setListOrderId}/edit`, {
      headers: {
        'Accept': 'text/html',
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      }
    })
    .then(response => response.text())
    .then(html => {
      if (!this.modal) {
        console.log('Creating new modal instance');
        this.initializeModal(); // モーダルのインスタンスを再初期化
      }

      const modalContent = this.modalElement.querySelector('.modal-content');
      if (modalContent) {
        modalContent.innerHTML = html;
      }
      
      console.log('Showing modal');
      this.modal.show();
    })
    .catch(error => {
      console.error('Error in openEditModal:', error);
    });
  }

  addSong(event) {
    console.log("=== Add Song Clicked ===");
    event.preventDefault();

    if (this.isRequestInProgress) {
      console.log('Request already in progress');
      return;
    }
    
    console.log("Form target in addSong:", this.formTarget);
    console.log("Report ID in addSong:", this.formTarget.dataset.reportId);
    console.log("Report ID:", this.formTarget.dataset.reportId);  // データセットから直接取得
    
    this.isRequestInProgress = true;
    const reportId = this.formTarget.dataset.reportId || event.currentTarget.dataset.reportId;
    if (!reportId) {
      console.error('Report ID is not available');
      return;
    }
        
    console.log("Making fetch request to:", `/reports/${reportId}/add_song`);
    
    fetch(`/reports/${reportId}/add_song`, {
      method: 'GET',
      headers: {
        'Accept': 'text/html',
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      },
      credentials: 'same-origin'
    })
    .then(response => {
      console.log("Fetch response:", response);
      return response.text();
    })
    .then(html => {
      console.log("Received HTML response");
      const modalElement = document.getElementById('song-modal');
      console.log("Modal element for content:", modalElement);
      
      if (modalElement) {
        const modalContent = modalElement.querySelector('.modal-content');
        console.log("Modal content element:", modalContent);
        
        if (modalContent) {
          modalContent.innerHTML = html;
          console.log("Modal content updated");
        }
        
        try {
          if (!this.modal) {
            console.log("Creating new modal instance");
            this.modal = new bootstrap.Modal(modalElement);
          }
          console.log("Showing modal");
          this.modal.show();
        } catch (error) {
          console.error('Error showing modal:', error);
        }
      } else {
        console.error("Modal element not found for content update");
      }
    })
    .catch(error => {
      console.error('Error in addSong:', error);
    })
    .finally(() => {
      console.log("Request completed");
      this.isRequestInProgress = false;
    });
  }

  closeModal(event) {
    if (event) event.preventDefault();
    if (this.modal) {
      this.modal.hide();
      this.removeBackdrop();
      
      // モーダル自体の状態もリセット
      const modalElement = document.getElementById('song-modal');
      if (modalElement) {
        modalElement.classList.remove('show');
        modalElement.style.display = 'none';
        modalElement.removeAttribute('aria-modal');
        
        // モーダルの内容をクリア
        const modalContent = modalElement.querySelector('.modal-content');
        if (modalContent) {
          modalContent.innerHTML = '';
        }
      }
    }
  }

  removeBackdrop() {
    // すべてのbackdropを取得して削除
    const backdrops = document.querySelectorAll('.modal-backdrop');
    backdrops.forEach(backdrop => {
      backdrop.classList.remove('show');  // アニメーション対策
      backdrop.remove();
    });
  
    // body要素のスタイルリセット
    document.body.classList.remove('modal-open');
    document.body.style.removeProperty('padding-right');
    document.body.style.removeProperty('overflow');
    
    // モーダル関連のすべてのクラスをリセット
    const modalElement = document.getElementById('song-modal');
    if (modalElement) {
      modalElement.classList.remove('show');
      modalElement.style.display = 'none';
      modalElement.removeAttribute('aria-modal');
    }
  }

  showFlashMessage(message, type = 'success') {
    const flashMessages = document.getElementById('flash-messages');
    if (flashMessages) {
      const alertClass = type === 'success' ? 'alert-success' : 'alert-danger';
      flashMessages.innerHTML = `
        <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
          ${message}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      `;
      
      // 3秒後にメッセージを消す
      setTimeout(() => {
        const alert = flashMessages.querySelector('.alert');
        if (alert) {
          alert.remove();
        }
      }, 3000);
    }
  }

  submitSong(event) {
    event.preventDefault();
  
    const form = event.target;
    const formData = new FormData(form);
    const data = {};
  
    // FormDataをJSON形式に変換
    formData.forEach((value, key) => {
      data[key] = value;
    });
  
    console.log("Submitting song data as JSON:", JSON.stringify(data)); // デバッグ用
  
    fetch(form.action, {
      method: 'PATCH',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': document.querySelector("[name='csrf-token']").content
      },
      body: JSON.stringify(data)
    })
    .then(response => {
      console.log("Response received with status:", response.status); // デバッグ用
      if (!response.ok) throw new Error("Network response was not ok");
      return response.json();
    })
    .then(data => {
      console.log("Response data:", data); // デバッグ用
      if (data.success) {
        const setListOrderId = form.closest('.modal-content')
          ?.querySelector('input[name="set_list_order[song_attributes][id]"]')?.value
          || form.dataset.setListOrderId;
  
        if (setListOrderId) {
          const songElement = document.getElementById(`song-${setListOrderId}`);
          if (songElement) {
            songElement.outerHTML = this.decodeHtmlEntities(data.html);
          }
        }
  
        if (this.modal) {
          this.modal.hide();
          this.removeBackdrop();
        }
  
        this.showFlashMessage(data.message || '曲情報が更新されました');
      } else {
        const errorContainer = form.querySelector('.error-messages');
        if (errorContainer) {
          errorContainer.innerHTML = (data.errors || []).map(error => 
            `<div class="alert alert-danger">${error}</div>`
          ).join('');
        }
      }
    })
    .catch(error => {
      console.error('Error:', error);
      this.showFlashMessage('エラーが発生しました', 'error');
    });
  }

  decodeHtmlEntities(html) {
    const txt = document.createElement('textarea');
    txt.innerHTML = html;
    return txt.value;
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

  removeSong(event) {
    const songItem = event.target.closest('.song-item')
    if (songItem) {
      songItem.remove()
      this.updateSongsCount()
      this.showFlashMessage('曲が削除されました', 'success')
    }
  }
}