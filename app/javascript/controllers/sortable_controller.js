import { Controller } from "@hotwired/stimulus"
import Sortable from 'sortablejs'

export default class extends Controller {
  static targets = ["songList"]

  connect() {
    console.log("Sortable controller connected!")
    
    // .section-songs 要素を取得
    const songListElement = this.element.querySelector('.section-songs')
    if (!songListElement) {
      console.error("Could not find .section-songs element")
      return
    }

    this.sortable = Sortable.create(songListElement, {
      animation: 150,
      handle: '.handle',
      group: 'songs',
      draggable: '.song-item', // ドラッグ可能な要素を明示的に指定
      onEnd: this.updateOrder.bind(this)
    })
  }

  updateOrder(event) {
    const sectionId = event.to.dataset.sectionId
    const reportId = this.element.dataset.reportId

    const newOrder = Array.from(event.to.querySelectorAll('.song-item')).map((item, index) => ({
      id: item.dataset.id,
      position: index + 1
    }))

    console.log("Updating order:", {
      sectionId,
      reportId,
      newOrder
    })

    fetch(`/reports/${reportId}/sections/${sectionId}/update_song_order`, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        song_order: newOrder,
        target_section_id: sectionId
      })
    })
    .then(response => {
      if (!response.ok) {
        return response.json().then(data => {
          throw new Error(data.error || 'Network response was not ok');
        });
      }
      return response.json();
    })
    .then(data => {
      console.log("Update successful:", data);
      this.updateSongNumbers();
    })
    .catch(error => {
      console.error("Error updating order:", error);
      const flashMessages = document.getElementById('flash-messages');
      if (flashMessages) {
        flashMessages.innerHTML = `<div class="alert alert-danger">更新に失敗しました: ${error.message}</div>`;
      }
    });
  }

  updateSongNumbers() {
    const songListElement = this.element.querySelector('.section-songs')
    if (songListElement) {
      songListElement.querySelectorAll('.song-item').forEach((item, index) => {
        const numberElement = item.querySelector('.song-number');
        if (numberElement) {
          numberElement.textContent = `${index + 1}.`;
        }
      });
    }
  }
}