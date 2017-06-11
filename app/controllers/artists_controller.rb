class ArtistsController < ApplicationController

  def index
    @artists = Artist.all    
  end

  def show
    @songs = Artist.find(params[:id]).songs
  end



end