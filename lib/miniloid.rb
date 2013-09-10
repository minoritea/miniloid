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
      @queue << [method_name, args, block]
      nil
    end
    
    def respond_to_missing? method_name, include_private = false
      @reciever.respond_to? method_name, include_private
    end
  end
  
  class InnerThread < Thread
    def initialize reciever, queue
      super reciever do |r,q|
        loop do
          _method, _args, _block = sq.pop
          case [!!_args,!!_block]
          when [true,true]
            r.__send__ _method, *_args, &_block
          when [true,false]
            r.__send__ _method, *_args
          when [false,true]
            r.__send__ _method, &_block
          when [false,false]
            r.__send__ _method
          end
        end 
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
