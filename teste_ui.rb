require 'test/unit'
require_relative 'io.rb'
require_relative 'ui.rb'

module Teste_Interface

class Teste_UI < Test::Unit::TestCase

	def test_dependencias
		@io = EntradaSaida::IO.new(true, true)
		assert !@io.nil?, "Nao foi possivel criar objeto IO!"
		
		oboard = Tabuleiro::Board.new(@DEBUG, @io)
		assert !oboard.nil?, "Nao foi possivel criar objeto board!"
		
		assert_raise(ArgumentError) { oboard = Tabuleiro::Board.new(@DEBUG, nil) }
	end

	def test_objetos
		assert_raise(ArgumentError) { oui = Interface::UI.new(true, nil) }
		@io = EntradaSaida::IO.new(true, true)
		oui = nil
		oui = Interface::UI.new(true, @io) 
		assert !oui.nil?, "Nao foi possivel criar objeto IO!"		
		oui = nil
		oui = Interface::UI.new(false, @io) 
		assert !oui.nil?, "Nao foi possivel criar objeto IO!"		
		oui = nil		
	end
	
	def test_Jogo_Tipo
		@io = EntradaSaida::IO.new(true, true)
		oui = Interface::UI.new(true, @io) 
		assert_equal 3, oui.Jogo_Tipo.length 
		
		oboard = Tabuleiro::Board.new(@DEBUG, @io)
		assert_equal oboard.Jogo_Tipo, oui.Jogo_Tipo 
		
		assert_raise(TypeError) { oui.get_Jogo_Tipo("A") } 
		
		oboard.Jogo_Tipo.each.with_index do |s, index|
			assert_equal s, oui.get_Jogo_Tipo(index)
		end
		
	end
	
	def test_Jogo_Level
		@io = EntradaSaida::IO.new(true, true)
		oui = Interface::UI.new(true, @io) 
		assert_equal 3, oui.Jogo_Level.length 

		oboard = Tabuleiro::Board.new(@DEBUG, @io)
		assert_equal oboard.Jogo_Level, oui.Jogo_Level 

		assert_raise(TypeError) { oui.get_Jogo_Level("A") } 
		
		oboard.Jogo_Level.each.with_index do |s, index|
			assert_equal s, oui.get_Jogo_Level(index)
		end
	end
end

end