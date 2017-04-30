require_relative 'io.rb'

module Tabuleiro

class Slots
  attr_accessor :compartimentos
  
  def initialize(pboDebug, pobjIO, pinTipoJogo = 1, pinNivelDificuldade = 2)
	@io = pobjIO      #classe para saída e entrada de informações com o usuário
    raise ArgumentError, "Erro de inicialização: Parâmetro do objeto 'io' nulo é inválido", "Slots.initialize" if @io.nil?
    limpar
  end
  
  def tabuleiro_vazio
	return ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
  end

  def limpar
	@compartimentos = tabuleiro_vazio
  end

  def to_s
    #retorna o tabuleiro atual
    " #{@compartimentos[0]} | #{@compartimentos[1]} | #{@compartimentos[2]} \n===+===+===\n #{@compartimentos[3]} | #{@compartimentos[4]} | #{@compartimentos[5]} \n===+===+===\n #{@compartimentos[6]} | #{@compartimentos[7]} | #{@compartimentos[8]} \n"
  end
  
  def print_slots(poSlots)
    #retorna o tabuleiro
    @io.write poSlots.to_s
  end
  
  def print
    #retorna o tabuleiro
    @io.write to_s
  end
    	
  def [](idx)     
    return @compartimentos[idx.to_i]
  end
  
  def set (index, valor)
	@compartimentos[index] = valor
  end
  
  def get (index)
	return @compartimentos[index]
  end
  
  def is_numeric(o)
	i = nil
	begin
		i = Integer(o)
    rescue
		return false
	end
	return true
  end
  
  public
  def slots_disponiveis()
	available_spaces = []
    @compartimentos.each do |s|
      if (is_numeric(s))
        available_spaces << s
      end
    end
	return available_spaces    
  end
  
  def game_is_over()
    #verificando se o tabuleiro apresenta as marca��es do vitoriozo
    b = @compartimentos.clone
    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1
  end

  def tudo_preenchido()
    b = @compartimentos.clone
    b.all? { |s| !is_numeric(s) } 
  end
  
  def tie()
    tudo_preenchido() && !game_is_over()
  end
end

end