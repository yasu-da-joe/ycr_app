class CreateSongs < ActiveRecord::Migration[7.2]
  def change
    create_table :songs do |t|
      t.string :name
      t.string :artist
      t.string :spotify_track_id
      t.string :spotify_url

      t.timestamps
    end
  end
end
