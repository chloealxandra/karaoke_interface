class SongsController < ApplicationController
  before_action :require_active_karaoke_session, only: [:confirm_cue, :enqueue, :skip, :remove, :play_pause]
  # before_action :set_song, only: [:show, :edit, :update, :destroy]

  @@kjams_database = "http://#{$kjams_api}"
  @@api_token = Rails.application.secrets.onsite_api_key
  # GET /songs
  # GET /songs.json
  # def index
  #   @songs = Song.all
  # end
  def index
    @songs = Song.search(params[:search])
  end


  #   @songs = Song.search(params[:search])
  # end

  # def artist_search
  #   @songs = Song.artist_search(song.artist)
  # end

  def confirm_cue
    @song = Song.find(params[:song])
    @singers = []
    karaoke_session = KaraokeSession.find session[:karaoke_session]
    room = KaraokeRoom.find karaoke_session.karaoke_room_id
    Rails.logger.debug "!!!!!!!!!!working with room number #{room.name}"
    room.singers.each do |e|
      unless (e["name"].empty? && e["siID"].empty?) 
        @singers << OpenStruct.new(:name => e["name"], :siID => e["siID"])
      end
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def request_passkey
  end

  def submit_passkey
    party = {}
    passkey_downcased = params[:passkey].downcase
    parties = KaraokeSession.where(token: passkey_downcased)
    parties.each do |p| 
      if p.is_active == "true"
        party = p
      end
    end
    if party.present?
      session[:karaoke_session] = party.id
      set_karaoke_session_cookie passkey_downcased
    else
      redirect_back( fallback_location: (request.referer || root_path), notice: "Sorry wrong passkey!")
    end
  end

  def enqueue
    puts "gonna enqueue song #{params[:song]}"
    if params[:'singer-dropdown'].present?
      singer_name = params[:'singer-dropdown']
    else 
      singer_name = params[:singer]
    end
    karaoke_session = KaraokeSession.find session[:karaoke_session]
    room = KaraokeRoom.find karaoke_session.karaoke_room_id
    Resque.enqueue(CueSong, *[room.name, singer_name, params[:song]])
    play = Play.new
    play.song_id = Song.find_by(soID: params[:song]).id
    play.user_id = current_user.id
    # play.karaoke_session_id = 
    play.save
    redirect_to "/karaoke_session/0", notice: "Song enqueued!"
  end

  # def skip
  #   puts "gonna skip a track!"
  #   response = HTTParty.post("#{@@kjams_database}/skip", query: {room: 0}, headers: {"Authorization" => "Token token=#{@@api_token}"})
  #   redirect_to "/karaoke_session/0", notice: "track skipped!!"
  # end

  # def remove
  #   puts "gonna remove a track!"
  #   response = HTTParty.post("#{@@kjams_database}/remove_current_song", query: {room: 0}, headers: {"Authorization" => "Token token=#{@@api_token}"})
  #   redirect_to "/karaoke_session/0", notice: "track removed!!"
  # end

  # def play_pause
  #   puts "changing play/pause state!"
  #   response = HTTParty.post("#{@@kjams_database}/play_pause", query: {room: 0}, headers: {"Authorization" => "Token token=#{@@api_token}"})
  #   redirect_to "/karaoke_session/0", notice: "changed play/pause!!"
  # end
    

  # # GET /songs/1
  # # GET /songs/1.json
  # def show
  # end

  # # GET /songs/new
  # def new
  #   @song = Song.new
  # end

  # GET /songs/1/edit
  # def edit
  # end

  # POST /songs
  # POST /songs.json
  # def create
  #   @song = Song.new(song_params)

  #   respond_to do |format|
  #     if @song.save
  #       format.html { redirect_to @song, notice: 'Song was successfully created.' }
  #       format.json { render :show, status: :created, location: @song }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @song.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # PATCH/PUT /songs/1
  # # PATCH/PUT /songs/1.json
  # def update
  #   respond_to do |format|
  #     if @song.update(song_params)
  #       format.html { redirect_to @song, notice: 'Song was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @song }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @song.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /songs/1
  # # DELETE /songs/1.json
  # def destroy
  #   @song.destroy
  #   respond_to do |format|
  #     format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
  # Use callbacks to share common setup or constraints between actions.
  def require_active_karaoke_session
    unless active_karaoke_session_check
      flash[:error] = "Sorry - not an active passkey!"
      if params[:song].present?
        session[:interrupted_songcue] = params[:song]
        redirect_to "/request_passkey"# halts request cycle
      else
      redirect_to "/request_passkey"# halts request cycle
      end
    end
  end

  def set_karaoke_session_cookie(passkey)
    if KaraokeSession.where(:token=>passkey).where(:is_active=>"true").first.present?
      karaoke_session = KaraokeSession.where(:token=>passkey).where(:is_active=>"true").first
      session[:karaoke_session] = karaoke_session.id
      if session[:interrupted_songcue].present?
        song = Song.find session[:interrupted_songcue]
        room = KaraokeRoom.find karaoke_session.karaoke_room_id
        Resque.enqueue(CueSong, *[room.name, current_user.username, song.soID])
        play = Play.new
        play.song_id = song.id
        play.user_id = current_user.id
        # play.karaoke_session_id = 
        play.save
        redirect_to "/karaoke_session/0", notice: "Song enqueued!"
      else
        redirect_to root_path, notice: "Welcome to the party!"
      end
    else
      redirect_to "/request_passkey"
    end
  end

  def active_karaoke_session_check
    if session[:karaoke_session].present?
      party = KaraokeSession.find session[:karaoke_session]
      if party.is_active == "true"
        if party.end_time > Time.now
          return true #party is going strong
        else
          set_party_to_limbo party
          return false #party is out of time and paused + set to limbo
        end
      else
        return false #party is already flagged as inactive or limbo
      end
    else
      return false #user doesn't have a karaoke_session in their cookie
    end
  end

  def set_party_to_limbo(party) #TODO CHANGE PLAYPAUSE TO AN EXPLICIT PAUSE check state of song (if playing wait till end)
    room = KaraokeRoom.find party.karaoke_room_id
    party.is_active = "limbo"
    party.save
    HTTParty.post("#{@@kjams_database}/play_pause", query: {room: room.name}, headers: {"Authorization" => "Token token=#{@@api_token}"})
  end

  # def set_song
  #   @song = Song.find(params[:id])
  # end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  # def song_params
  #   params.require(:song).permit(:title, :artist, :location, :category)
    
  # end

    # def play_pause
    #   HTTParty.post("#{@@server_url}/play_pause", query: {room: params[:room], token: params[:token]})
    # end
end
