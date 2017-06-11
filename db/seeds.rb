User.create(username: "host", email: "host@cuesong.io", password: "capitol_karaoke", admin: "true")

#create rooms
[1,2,3,4].each {|room| KaraokeRoom.new({name: room}).save}
