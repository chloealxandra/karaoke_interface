class KaraokeRoomsController < ApplicationController

  def index
    @karaoke_rooms = KaraokeRoom.all
  end

  def new
    @karaoke_room = KaraokeRoom.new
  end

  #post karaoke_room/:id
  def show
    @singers = KaraokeRoom.find_by(name: params[:id]).singers
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @singers }
    end
  end

  # def create
  #   @karaoke_room = KaraokeRoom.create(karaoke_room_params)
  #   if @karaoke_room.save
  #     name = @karaoke_room.name
  #     redirect_to karaoke_rooms_path
  #     flash[:notice] = "#{name} created"
  #   else
  #     render 'new'
  #     flash[:error] = "Unable to create karaoke room. Please try again"
  #   end
  # end

  # def destroy
  #   @karaoke_room = KaraokeRoom.find(params[:id])
  #   @karaoke_room.destroy
  #   redirect_to karaoke_rooms_path
  # end

  # def edit
  #   @karaoke_room = KaraokeRoom.find(params[:id])
  # end

  # def update
  #   @karaoke_room = KaraokeRoom.find(params[:id])
  #   @karaoke_room.update karaoke_room_params
  #   if @karaoke_room.save
  #     flash[:notice] = "Your karaoke room was updated succesfully"
  #     redirect_to root_path
  #   else
  #     render 'edit'
  #   end
  # end

  private

    def karaoke_room_params
      params.require(:karaoke_room).permit(:name, :delete)
    end

end
