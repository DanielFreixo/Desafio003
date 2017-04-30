require 'test/unit'
require_relative 'io.rb'
require_relative 'slots.rb'

module Teste_Tabuleiro

class Teste_Slots < Test::Unit::TestCase

	def test_dependencias
		@io = EntradaSaida::IO.new(true, true)
		assert !@io.nil?, "Nao foi possivel criar objeto IO!"
		
		@slots = Tabuleiro::Slots.new(true, @io)
		raise ArgumentError, "Erro de inicializacao: objeto 'Slots' nulo é inválido", "slots.initialize" if @slots.nil?  

		assert_raise(ArgumentError) { @slots = Tabuleiro::Slots.new(@DEBUG, nil) }		
	end
	
	def test_slots_vazios_e_disponiveis
		@io = EntradaSaida::IO.new(true, true)
		@slots = Tabuleiro::Slots.new(true, @io, 1, 2)
		@slots.limpar
		assert_equal @slots.compartimentos, @slots.tabuleiro_vazio
		assert_equal @slots.slots_disponiveis, @slots.tabuleiro_vazio
	end
	
	def test_slots_get_set_e_disponiveis
		@io = EntradaSaida::IO.new(true, true)
		@slots = Tabuleiro::Slots.new(true, @io, 1, 2)
		@slots.limpar
		assert_equal @slots.slots_disponiveis, @slots.tabuleiro_vazio
		for i in 0..8
			assert_equal @slots.get(i).to_i, i
		end		
		for i in 0..8
			@slots.set i, "X"
			@io.write @slots.slots_disponiveis.to_s + " " + @slots.slots_disponiveis.count.to_s
			assert_equal @slots.slots_disponiveis.count, 8-i 
		end
	    @slots.set 10, "X"
	    @slots.set -10, "X"
	end
	
	def test_tie
		@io = EntradaSaida::IO.new(true, true)
		@slots = Tabuleiro::Slots.new(true, @io, 1, 2)
		i = 0
		while @slots.slots_disponiveis.count > 0 do
			@slots.set(i, "X")
			@io.write i.to_s + ") " + @slots.slots_disponiveis.to_s + " " + @slots.slots_disponiveis.count.to_s
			assert_equal @slots.slots_disponiveis.count, 8 - i
			i +=1
		end
		@io.write @slots.slots_disponiveis.to_s + " " + @slots.slots_disponiveis.count.to_s
		assert_equal @slots.slots_disponiveis.count, 0
		@io.write @slots.to_s
		assert @slots.game_is_over
		assert @slots.tudo_preenchido
		assert !@slots.tie		
	end	
end

end