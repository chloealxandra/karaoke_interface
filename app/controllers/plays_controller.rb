class PlaysController < ApplicationController
  def index
    @plays = current_user.plays
  end

  #GET capitol_hits
  def top_plays
    @songs = Song.rankSongsByPlays
    render 'capitol_hits'
  end

end