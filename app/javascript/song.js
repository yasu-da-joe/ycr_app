document.addEventListener('turbolinks:load', () => {
    const addSongBtn = document.getElementById('add-song-btn');
    const modal = document.getElementById('add-song-modal');
    console.log('Script loaded');
    const addSongToListBtn = document.getElementById('add-song-to-list');
    console.log('Add Song Button:', addSongBtn);
    const tempSongList = document.getElementById('temp-song-list');
    const tempSongs = [];

    if (addSongBtn) {
        addSongBtn.addEventListener('click', () => {
          console.log('Add Song Button clicked');
          $('#add-song-modal').modal('show');
        });
    }
    
    addSongBtn.addEventListener('click', () => {
      $(modal).modal('show');
    });
  
    addSongToListBtn.addEventListener('click', () => {
      const name = document.getElementById('song-name').value;
      const artist = document.getElementById('song-artist').value;
      const impression = document.getElementById('song-impression').value;
  
      if (name && artist) {
        tempSongs.push({ name, artist, impression });
        updateTempSongList();
        $(modal).modal('hide');
        clearModalInputs();
      }
    });
  
    function updateTempSongList() {
      tempSongList.innerHTML = tempSongs.map(song => 
        `<li>${song.name} - ${song.artist}</li>`
      ).join('');
    }
  
    function clearModalInputs() {
      document.getElementById('song-name').value = '';
      document.getElementById('song-artist').value = '';
      document.getElementById('song-impression').value = '';
    }
  
    // フォーム送信時に一時的な曲リストを含める
    document.querySelector('form').addEventListener('submit', (e) => {
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = 'temp_song_list';
      input.value = JSON.stringify(tempSongs);
      e.target.appendChild(input);
    });
});