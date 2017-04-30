require 'test/unit'
require_relative 'gum.rb'

class GumTest < Test::Unit::TestCase
  def test_crisis
    g = Gum.new
    assert_equal -42, g.crisis
  end
end