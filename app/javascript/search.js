document.addEventListener("DOMContentLoaded", () => {
  const artistInput = document.getElementById("artist-search");
  const trackInput = document.getElementById("track-search");
  const artistSuggestionsDiv = document.getElementById("artist-suggestions");
  const trackSuggestionsDiv = document.getElementById("track-suggestions");
  const selectedArtistDiv = document.getElementById("selected-artist");
  const trackSearchContainer = document.getElementById("track-search-container");
  const searchResultsDiv = document.getElementById("search-results");
  const selectedTrackDiv = document.getElementById("selected-track");
  let selectedArtistName = null;
  let debounceTimer;
  let selectedArtistId = null;

  if (artistInput) {
    artistInput.addEventListener("input", handleArtistInput);
  }

  if (trackInput) {
    trackInput.addEventListener("input", handleTrackInput);
  }

  function handleArtistInput(e) {
    const query = e.target.value;
    clearTimeout(debounceTimer);

    if (query.length > 0) {
      debounceTimer = setTimeout(() => {
        fetchArtistSuggestions(query);
      }, 200);
    } else {
      artistSuggestionsDiv.innerHTML = "";
    }
  }

  function handleTrackInput(e) {
    const query = e.target.value;
    console.log("Track input:", query, "Selected artist:", selectedArtistName);
  
    clearTimeout(debounceTimer);
  
    if (query.length > 0 && selectedArtistName) {
      debounceTimer = setTimeout(() => {
        fetchTrackSuggestions(query, selectedArtistName);
      }, 200);
    } else {
      trackSuggestionsDiv.innerHTML = "";
    }
  }  

  function fetchArtistSuggestions(query) {
    fetch(`/search/suggest_artists?query=${encodeURIComponent(query)}`)
      .then((response) => response.json())
      .then((data) => {
        artistSuggestionsDiv.innerHTML = "";
        data.forEach((artist) => {
          const div = document.createElement("div");
          div.innerHTML = `
            ${artist.name} 
            <button class="select-artist" data-id="${artist.id}" data-name="${artist.name}">選択</button>
          `;
          artistSuggestionsDiv.appendChild(div);
        });

        // 選択ボタンにイベントリスナーを追加
        document.querySelectorAll('.select-artist').forEach(button => {
          button.addEventListener('click', selectArtist);
        });
      })
      .catch((error) => console.error("Error:", error));
  }

  function selectArtist(e) {
    const artistId = e.target.dataset.id;
    const artistName = e.target.dataset.name;
    selectedArtistId = artistId;
    selectedArtistName = artistName;
    selectedArtistDiv.textContent = `選択されたアーティスト: ${artistName}`;
    artistInput.value = "";
    artistSuggestionsDiv.innerHTML = "";
    trackSearchContainer.style.display = "block";
    trackInput.focus();
  }

  function fetchTrackSuggestions(query, artistName) {
    console.log("Fetching tracks for:", query, "Artist:", artistName);
    const url = `/search/suggest_tracks?query=${encodeURIComponent(query)}&artist_name=${encodeURIComponent(artistName)}`;
    console.log("Request URL:", url);
    
    fetch(url)
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`);
        }
        return response.json();
      })
      .then((data) => {
        console.log("Received track data:", data);
        trackSuggestionsDiv.innerHTML = "";
        if (data.length === 0) {
          trackSuggestionsDiv.innerHTML = "<p>No matching tracks found. Try a different search term.</p>";
        } else {
          data.forEach((track) => {
            const div = document.createElement("div");
            div.innerHTML = `
              ${track.name} - ${track.album}
              <button class="select-track" data-track='${JSON.stringify(track)}'>選択</button>
            `;
            trackSuggestionsDiv.appendChild(div);
          });

          // 選択ボタンにイベントリスナーを追加
          document.querySelectorAll('.select-track').forEach(button => {
            button.addEventListener('click', selectTrack);
          });
        }
      })
      .catch((error) => {
        console.error("Error fetching tracks:", error);
        trackSuggestionsDiv.innerHTML = "<p>Error fetching tracks</p>";
      });
  }

  function selectTrack(e) {
    const trackData = JSON.parse(e.target.dataset.track);
    displayTrackDetails(trackData);
    trackInput.value = trackData.name;
    trackSuggestionsDiv.innerHTML = "";
  }

  function displayTrackDetails(track) {
    selectedTrackDiv.innerHTML = `
      <h3>選択された曲:</h3>
      <p>曲名: ${track.name}</p>
      <p>アーティスト: ${track.artists.join(', ')}</p>
      <p>アルバム: ${track.album}</p>
      <p>リリース日: ${track.release_date}</p>
    `;
  }
});