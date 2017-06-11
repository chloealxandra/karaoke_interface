Rails.application.routes.draw do
  resources :karaoke_rooms do
	  resources :bookings
	end
  resque_web_constraint = lambda { |request| request.remote_ip == '127.0.0.1' }
    constraints resque_web_constraint do
    mount Resque::Server, :at => "/resque"
  end
  devise_for :users
  resources :songs, :artists, :karaoke_session, :plays, :favorites, :karaoke_rooms
  # get dashboard
  post "/enqueue" => "songs#enqueue"
  get "confirm_cue" => "songs#confirm_cue"
  post "confirm_cue" => "songs#confirm_cue"
  post "confirm_end_session" => "karaoke_session#confirm_end_session"
  get "confirm_favorite" => "favorites#confirm_favorite"
  post "confirm_favorite" => "favorites#confirm_favorite"  
#get 'home/index'
  root :to => "songs#index"
  post "skip" => "songs#skip"
  post "remove" => "songs#remove"
  post "play_pause" => "songs#play_pause"
  post "/karaoke_session/refresh_queued_songs/:id" => "karaoke_session#refresh_queued_songs"
  get "/karaoke_session/refresh_queued_songs/:id" => "karaoke_session#refresh_queued_songs"
  get "/request_passkey" => "songs#request_passkey"
  post "/submit_passkey" => "songs#submit_passkey"
  get "capitol_hits" => "plays#top_plays"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  devise_for :admins
  

end
