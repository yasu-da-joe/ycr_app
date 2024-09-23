class SearchController < ApplicationController
  def index
  end

  def suggest_artists
    query = params[:query]
    if query.present?
      RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])
      artists = RSpotify::Artist.search(query, limit: 5, market: "JP")
      suggestions = artists.map { |artist| { id: artist.id, name: artist.name } }
      render json: suggestions
    else
      render json: []
    end
  rescue => e
    Rails.logger.error "Error searching artists: #{e.message}"
    render json: [], status: :internal_server_error
  end

  def suggest_tracks
    Rails.logger.info "Received params for suggest_tracks: #{params.inspect}"
    artist_name = params[:artist_name]
    track_query = params[:query]

    if artist_name.present? && track_query.present?
      RSpotify.authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_CLIENT_SECRET"])

      # アーティスト名と曲名の組み合わせで検索
      search_query = "artist:#{artist_name} track:#{track_query}"
      tracks = RSpotify::Track.search(search_query, limit: 10, market: "JP")

      suggestions = tracks.map do |track|
        {
          id: track.id,
          name: track.name,
          album: track.album.name,
          artists: track.artists.map(&:name),
          release_date: track.album.release_date
        }
      end

      render json: suggestions
    else
      render json: []
    end
  rescue => e
    Rails.logger.error "Error searching tracks: #{e.message}"
    render json: [], status: :internal_server_error
  end
end
