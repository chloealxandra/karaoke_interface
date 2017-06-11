require 'active_support/concern'

class Booking < ActiveRecord::Base
  include Bookable
end