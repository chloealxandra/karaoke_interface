class Song < ApplicationRecord
  has_many :plays
  has_many :users, through: :plays

  has_many :favorites
  has_many :users, through: :favorites

  include PgSearch
  multisearchable :against => :title,
                    :using => {
                    :tsearch => {:dictionary => "english"}
                  }

  belongs_to :artist

  @@api_token = Rails.application.secrets.onsite_api_key
  @@kjams_database = "http://#{$kjams_api}/"
  def self.import_all_songs
    songs_exist = Song.all.collect{ |e| e[:soID]}
    response = HTTParty.post("#{@@kjams_database}get_all_songs", headers: {"Authorization" => "Token token=#{@@api_token}"})
    response.each do |e|
      if ((songs_exist.include? e["soID"]) == false)
        song = Song.new 
        song.soID = e["soID"]
        # song.artist_id = e["arts"]
        song.title = e["name"]
        if Artist.where({name: e["arts"]}).empty?
          artist = Artist.new
          artist.name = e["arts"]
          artist.save
          song.artist_id = artist.id
        else
          song.artist_id = Artist.find_by({name: e["arts"]}).id
        end
        song.save
     end
   end
  end


  def self.search(search)
    songs = []
    results = PgSearch.multisearch(search)
    results.each do |result|
      if result.searchable_type == "Artist"
        songs << Artist.find(result.searchable_id).songs
      else result.searchable_type == "Song"
        songs << Song.find(result.searchable_id)
      end
    end
    songs.flatten!
    return songs
  end

  def self.rankSongsByPlays #this logic should maybe change to Song.all once the plays table is bigger than the songs table?
    #Better approach ideas:
  # 13:21 <@xnor> maybe something in here? http://api.rubyonrails.org/classes/ActiveRecord/Calculations.html
  # 13:27 <@xnor> AR might be able to do it directly, Play.calculate(:count, :song_id).order(:count).limit(100) ?
  # 13:28 <@xnor> Play.calculate(:count, :song_id).order(:count).limit(100).pluck(:song_id).. something like that
    ranked_plays = [] #[{song_id: foo, play_count: bar}, etc]
    top_songs = []
    Play.all.each do |p|
      if ranked_plays.any? {|h| h[:song_id] == p.song_id} 
        song = ranked_plays.find {|h| h[:song_id] == p.song_id}
        song[:play_count] += 1 
      else
        ranked_plays << {song_id: p.song_id, play_count: 1}
      end 
    end
    ranked_plays.sort! {|x,y| y[:play_count] <=> x[:play_count]}
    ranked_plays[0,99].each do |s|
      song = Song.find s[:song_id]
      top_songs << song
    end
    return top_songs
  end

end
