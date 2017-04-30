require 'test/unit'
require_relative 'io.rb'

module EntradaSaida
	
class Teste_IO < Test::Unit::TestCase
	#include Test::Unit::Assertions
	
	def test_criacao_objetos
		io = EntradaSaida::IO.new(false)
		assert !io.nil?, "Nao foi possivel criar objeto IO!"
		io = nil
		io = EntradaSaida::IO.new(true)
		assert !io.nil?, "Nao foi possivel criar objeto IO com debug!"
	end
		
	def test_valida_entrada_usuario
		io = EntradaSaida::IO.new(true)
		assert_equal 0, io.valida_entrada_usuario_numerica("0", 0, 0)
		assert_equal 0, io.valida_entrada_usuario_numerica("0", 0, 1)
		assert_equal 1, io.valida_entrada_usuario_numerica("1", 0, 1)
		assert_equal 0, io.valida_entrada_usuario_numerica("0", -1, 1)
		assert_equal 0, io.valida_entrada_usuario_numerica("0", -1, 0)
		assert_equal nil, io.valida_entrada_usuario_numerica("0", 0, -1)
		assert_equal nil, io.valida_entrada_usuario_numerica("0", -1, -2)				
		assert_raise(ArgumentError) { io.valida_entrada_usuario_numerica("X", 0, 2) }
		retorno = io.valida_entrada_usuario_numerica(rand(0..10), 0, 10)
		assert_includes 0..10, retorno 
	end
	
	def set_get_action(io, valor)
		#simula a entrada do usuário pelo console
		p = proc { valor.to_s }
		define_singleton_method_by_proc(io, :get_action, p)
	end
   
    def define_singleton_method_by_proc(obj, name, block)
		metaclass = class << obj; self; end
		metaclass.send(:define_method, name, block)
	end
	
	def test_entre_com_uma_opcao
		io = EntradaSaida::IO.new(true, true)
		set_get_action(io, "0")
		assert_equal 0, io.entre_com_uma_opcao(0, 10)
				
		set_get_action(io, rand(0..10))
		retorno = io.entre_com_uma_opcao(0, 10)
		assert_includes 0..10, retorno
		
		set_get_action(io, "A")
		retorno = io.entre_com_uma_opcao(0, 3)
		assert_equal nil, retorno
		
		set_get_action(io, "10")
		retorno = io.entre_com_uma_opcao(10, 20)
		assert_equal 10, retorno
	end

	def test_game_type
		io = EntradaSaida::IO.new(true, true)
		set_get_action(io, "0")
		retorno = io.getGameType()
		assert_equal 0, retorno
				
		set_get_action(io, "1000")
		retorno = io.getGameType()
		assert_equal nil, retorno
		
		set_get_action(io, "-1")
		assert_equal nil, io.getGameType
		
		set_get_action(io, "A")
		retorno = io.getGameType()
		assert_equal nil, retorno
	end
	
	def test_game_level
		io = EntradaSaida::IO.new(true, true)
		set_get_action(io, "0")
		retorno = io.GetGameLevel()
		assert_equal 0, retorno
		
		set_get_action(io, "3")		
		begin
		  retorno = io.GetGameLevel()
		rescue SystemExit => e
		  assert e.status == 0
		end
					
		set_get_action(io, "1000")
		retorno = io.GetGameLevel()
		assert_equal 2, retorno
		
		set_get_action(io, "-1")
		assert_equal 2, io.GetGameLevel
		
		set_get_action(io, "A")
		retorno = io.GetGameLevel()
		assert_equal 2, retorno
	end
	
	def test_write
		io = EntradaSaida::IO.new(true, true)
		io.write "test_write ... writing"		
		io.write "nil"
		io.write nil		
	end
	
end

end
