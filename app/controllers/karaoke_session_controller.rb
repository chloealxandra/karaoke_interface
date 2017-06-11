class KaraokeSessionController < ApplicationController
    before_filter :authorize_admin, only: [:index, :create, :confirm_end_session, :destroy] 
  @@server_url = "http://#{$kjams_api}"

  def index
    @rooms = KaraokeRoom.all
    @active_sessions = KaraokeSession.where(is_active: "true")
    @inactive_rooms = []
    KaraokeRoom.all.each do |room|
      unless room.karaoke_sessions.find_by(is_active: "true")
        @inactive_rooms << room
      end
    end
    #KaraokeRoom.all.first.karaoke_sessions
  end

  def create
    # add a singer and queue wiping API call to this!
    @rooms = KaraokeRoom.all
    if params[:length].present?
      @karaoke_session = KaraokeSession.new
      @karaoke_session.end_time = Time.now + params[:length].to_i.hours
      @karaoke_session.is_active = "true"
      @karaoke_session.token = Haikunator.haikunate(0, ' ')
      @karaoke_session.karaoke_room_id = KaraokeRoom.find_by(name: params[:room]).id
      @karaoke_session.start_time = Time.now
      @karaoke_session.save
      render :index
    else
      Rails.logger.debug "!!!! no hours!!!!!!!"
      flash[:notice] = "You need to include hours!"
      redirect_to karaoke_session_index_url 
    end

  end

  def confirm_end_session
    @karaoke_session = KaraokeSession.find params[:karaoke_session]
    @karaoke_room = KaraokeRoom.find @karaoke_session.karaoke_room_id
    Rails.logger.debug "!!!!!!! @karaoke_session is  @karaoke_session and params is #{params}"
    respond_to do |format|
      format.html
      format.js
    end
  end
  def destroy
    @rooms = KaraokeRoom.all
    @karaoke_session = KaraokeSession.find params[:id]
    @karaoke_session.is_active = "false"
    @karaoke_session.save
    redirect_to karaoke_session_index_url
  end

  def show
    @room = params[:id].to_i + 1
    karaoke_room = KaraokeRoom.find_by(name: @room)
    @queued_songs = karaoke_room.queue
    respond_to do |format|
      format.html
      format.json{
        render :json => @queued_songs.to_json
      }
    end
  end

  def refesh_queued_songs #can't get this code to run from the ajax for some reason - jumps straight to js with now instance variable
    @room = params[:id].to_i + 1
    karaoke_room = KaraokeRoom.find_by(name: @room)
    @queued_songs = karaoke_room.queue
    respond_to do |format|
      format.js
    end
  end

end
