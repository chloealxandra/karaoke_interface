class FavoritesController < ApplicationController
  def index
    @favorites = current_user.favorites
  end

  def create
    song_id = Song.find_by(soID: params[:song]).id
    if current_user.favorites.any? {|f| f.song_id == song_id}
        redirect_back( fallback_location: (request.referer || root_path), notice: "this song is already in your favorites")
    else
      favorite = Favorite.new
      favorite.song_id = Song.find_by(soID: params[:song]).id
      favorite.user_id = current_user.id
      # play.karaoke_session_id = 
      favorite.save
        redirect_back( fallback_location: (request.referer || root_path), notice: "song has been added to your favorites")
    end    
  end

  def confirm_favorite
      @song = Song.find(params[:song])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def destroy
    favorite = Favorite.find(params[:id])
    favorite.destroy
      redirect_to favorites_path, :notice => "favorite has been deleted"
  end

end