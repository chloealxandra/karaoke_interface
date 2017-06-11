class QueueGrabber
  @queue = :updaters
  @server_url = "http://#{$kjams_api}"
  @@api_token = Rails.application.secrets.onsite_api_key

  def self.perform(room)
    r = KaraokeRoom.find_by(name: room)
    response = HTTParty.post("#{@server_url}/get_queue", query: {room: r.name}, headers: {"Authorization" => "Token token=#{@@api_token}"})
    #this is always running right now - it would be better if it only runs when a change has been made!
    r.queue = response.parsed_response
    r.save
  end
end