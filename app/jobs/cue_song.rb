class CueSong
  @queue = :api_control
  @@server_url = "http://#{$kjams_api}"
  @@api_token = Rails.application.secrets.onsite_api_key

  def self.perform (*args)
    puts "cue'ing song for singer #{args[1]}"
    res = HTTParty.post("#{@@server_url}/enqueue", query: {room: args[0], singer: args[1], song: args[2]}, headers: {"Authorization" => "Token token=#{@@api_token}"})
    case res.code
      when 200
        return true
      when 404
        return "404 error"
      when 500...600
        return "ERROR #{res.code}"
    end    
  end

end