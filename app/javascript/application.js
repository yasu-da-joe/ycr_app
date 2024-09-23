import "@hotwired/turbo-rails"
import "./controllers"

// 既存のフラッシュメッセージ制御コード
function setupFlashMessages() {
    const flashMessages = document.getElementById('flash-messages');
    if (flashMessages) {
      flashMessages.addEventListener('click', removeFlashMessage);
      
      // 各フラッシュメッセージに対して自動消去を設定
      const alerts = flashMessages.querySelectorAll('.alert');
      alerts.forEach(alert => {
        setTimeout(() => {
          removeFlashMessage({ target: alert.querySelector('.close') });
        }, 2000); // 2秒後に消去
      });
    }
  }
  
  function removeFlashMessage(event) {
    const closeButton = event.target.closest('.close');
    if (closeButton) {
      const alert = closeButton.closest('.alert');
      if (alert) {
        alert.remove();
        checkAndRemoveFlashContainer();
      }
    }
  }
  
  function checkAndRemoveFlashContainer() {
    const flashMessages = document.getElementById('flash-messages');
    if (flashMessages && flashMessages.children.length === 0) {
      flashMessages.remove();
    }
  }
  
  document.addEventListener('DOMContentLoaded', setupFlashMessages);
  document.addEventListener('turbo:load', setupFlashMessages);
  document.addEventListener('turbo:render', setupFlashMessages);
  
  // グローバルTurboイベントリスナー
  document.addEventListener('click', (event) => {
    const closeButton = event.target.closest('.close');
    if (closeButton && closeButton.closest('#flash-messages')) {
      removeFlashMessage(event);
    }
  });
  // フラッシュメッセージ制御ここまで