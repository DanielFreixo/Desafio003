require 'test/unit'
require_relative 'io.rb'
require_relative 'board.rb'

module Tabuleiro

class Teste_Board < Test::Unit::TestCase

	def test_dependencias
		@io = EntradaSaida::IO.new(true, true)
		assert !@io.nil?, "Nao foi possivel criar objeto IO!"
	end
	
end

end