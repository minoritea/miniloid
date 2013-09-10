require "miniloid/version"
require "thread"

module Miniloid
  class Proxy
    def initialize object
      @reciever = object
      @queue = Queue.new
      InnerThread.new @reciever, @queue
    end
    
    def method_missing method_name, *args, &block
      raise StandardError.new(:NoSuchMethod) unless @reciever.respond_to? method_name
      @queue << [self, method_name, args, block]
      nil
    end
    
    def respond_to_missing? method_name, include_private = false
      @reciever.respond_to? method_name, include_private
    end
  end
  
  class InnerThread < Thread
    def initialize reciever, queue
      super do
        loop do
          _context, _method, _args, _block = queue.pop
          Actor.current = _context
          case [!!_args,!!_block]
          when [true,true]
            reciever.__send__ _method, *_args, &_block
          when [true,false]
            reciever.__send__ _method, *_args
          when [false,true]
            reciever.__send__ _method, &_block
          when [false,false]
            reciever.__send__ _method
          end
        end 
      end
    end
    
  end
  
  class Actor
    class << self
      def current
        ct = Thread.current
        (InnerThread === ct && ct[:context]) ? ct[:context] : nil
      end
      def current= context
        Thread.current[:context] = context
      end
    end
  end
  
  class << self
    def included klass
      class << klass
        def new
          instance = super
          Proxy.new instance
        end
      end
    end
  end
end
