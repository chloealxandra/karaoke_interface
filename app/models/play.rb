class Play < ApplicationRecord
  belongs_to :user
  belongs_to :song
  belongs_to :karaoke_session
end
