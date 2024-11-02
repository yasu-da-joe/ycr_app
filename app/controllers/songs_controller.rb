class SongsController < ApplicationController
  def new
    @report = Report.find(params[:report_id])
    @song = @report.songs.new
    render partial: 'add_song_form', layout: false
  end

  def create
    @report = Report.find(params[:report_id])
    @song = @report.songs.new(song_params)
    if @song.save
      render partial: 'song', locals: { song: @song, report: @report }
    else
      render partial: 'add_song_form', status: :unprocessable_entity
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    head :no_content
  end

  private

  def song_params
    params.require(:song).permit(:name, :artist, :impression)
  end
end