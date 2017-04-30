require_relative 'board.rb'
require_relative 'io.rb'

module Interface  
  include Tabuleiro
  
class UI
  attr_accessor :Jogo_Tipo
  attr_accessor :Jogo_Level
  
  def initialize(pboDebug, io)
    @DEBUG = pboDebug
    @board = nil
	raise ArgumentError, "Erro de inicialização: Parâmetro do objeto 'io' nulo é inválido", "ui.initialize" if io.nil?
    @io = io
	@Jogo_Tipo = ['Humano vs CPU', 'CPU vs CPU', 'Humano vs Humano']
    @Jogo_Level = ['Fácil', 'Médio', 'Difícil']
    #@nivel_dificuldade = 2 #'0-Fácil', '1-Médio', '2-Difícil'#
  end

  def JogarJogoDaVelha
    iniciar_jogo_da_velha()
  end
  
  def get_Jogo_Tipo(pinOpcao)
    #Tipos de jogos disponíveis
    return @Jogo_Tipo[pinOpcao].to_s
  end
  
  def get_Jogo_Level(pinOpcao)
    #niveis de dificuldade disponíveis
    return @Jogo_Level[pinOpcao].to_s
  end
  
  def escolher_tipo_jogo
	tipo_jogo = 0
	tipo_jogo = @io.getGameType() #pegando escolha do usuário
    @io.write "Você escolheu a opção '" + get_Jogo_Tipo(tipo_jogo) + "'"
	return tipo_jogo
  end
  
  def escolher_tipo_dificuldade(pinTipo_jogo)
    nivel_dificuldade = 2 #dificuldade padrão
    if (pinTipo_jogo == 0 || pinTipo_jogo == 1)
		#Caso haja algum CPU envolvido, na partida é possível escolher o nível de dificuldade!      
		nivel_dificuldade = @io.GetGameLevel()
		@io.write "Você escolheu o nível '" + get_Jogo_Level(nivel_dificuldade) + "'"
    end
	return nivel_dificuldade
  end  
    
  def parabenizar_vencedor(pinVencedor)
	if (pinVencedor!=0)
		@io.write "\n\n\nPARABÉNS JOGADOR #{pinVencedor}!!!"
	else
		@io.write "\n\n\nBOA SORTE NA PRÓXIMA!!!"
	end
  end
  
  def chamar_tabuleiro_de_jogo_da_velha(pinTipo_jogo, pinNivel_dificuldade)
	@io.write "\n\nVamos começar:\n\n"    
	@board = Tabuleiro::Board.new(@DEBUG, @io, pinTipo_jogo, pinNivel_dificuldade) #criando classe responsável pelo jogo
	@board.limpa_tabuleiro
	return @board.start_the_game().to_i
  end

  def iniciar_jogo_da_velha
    # Tipo de Jogo
    tipo_jogo = escolher_tipo_jogo    
	# Escolher tipo de dificuldade
    nivel_dificuldade = escolher_tipo_dificuldade(tipo_jogo)
    # Começando
	vencedor = chamar_tabuleiro_de_jogo_da_velha(tipo_jogo, nivel_dificuldade)
    #Informação apenas dada quando há jogadores humanos
	parabenizar_vencedor vencedor if tipo_jogo != 1
  end

end

end