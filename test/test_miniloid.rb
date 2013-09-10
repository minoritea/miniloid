require 'minitest/autorun'
require 'miniloid'
class MiniloidTest < Minitest::Test
  def test_defined
    assert defined?(Miniloid)
  end
  
  def test_define_actor
    klass = Class.new do
      include Miniloid
    end
    assert klass
    actor = klass.new
    assert_kind_of Miniloid::Proxy, actor
  end
  
  def test_async_call
    klass = Class.new do
      include Miniloid
      def test
        :test
      end
    end
    actor = klass.new
    assert_equal nil, actor.test
    assert_raises StandardError do
      actor.magic
    end
  end
end