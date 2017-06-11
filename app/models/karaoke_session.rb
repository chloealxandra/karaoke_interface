class KaraokeSession < ApplicationRecord
  belongs_to :room
  has_and_belongs_to_many :users
  validates :end_time, presence: true

  # def self.generate_token
  #   arr = KaraokeSession.all.collect{ |e| e[:token]}
  #   arr << 'first'
  #   token = 'first'
  #   until ((arr.include? token) == false) do
  #     chars = ['a'..'z', '0'..'9'].map{|r|r.to_a}.flatten
  #     token = Array.new(6).map{chars[rand(chars.size)]}.join
  #   end
  #   return token
  # end

end
