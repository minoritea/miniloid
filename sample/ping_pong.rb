$:.unshift File.expand_path("../../lib",__FILE__)
require 'miniloid'
class MyActor
  include Miniloid
  def ping_pong actor, i
    p Thread.current
    actor.ping_pong Actor.current, i - 1 if i > 0
  end
end
a = MyActor.new
b = MyActor.new
a.ping_pong b, 5
sleep 1