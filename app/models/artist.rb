class Artist < ApplicationRecord
	has_many :songs

  include PgSearch
  multisearchable :against => :name,
                    :using => {
                    :tsearch => {:dictionary => "english"}
                  }
  end

  # artist = Artist.new
  #   artist.name = ["name"]
  # artist.save

 

# private
#   def self.song_search(artist)
#     results = []
#     results << Artist.where({ name: artist })
#     results.flatten
#       results.each do |s|
#         results << s.songs
#     end 
#   end


# end
