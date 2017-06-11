require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork
  handler do |job|
    puts "Running #{job}"
  end

  every(10.seconds, 'Grab queues', tz: 'UTC') { Resque.enqueue(QueueGrabber, 1) }
  every(30.seconds, 'Get singers', tz: 'UTC') { Resque.enqueue(GetSingers, 1) }
end