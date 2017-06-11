class KaraokeRoom < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :bookings
  has_many :karaoke_sessions
end
