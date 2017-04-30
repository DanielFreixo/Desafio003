require_relative 'io.rb'
require_relative 'slots.rb'

module Tabuleiro

class Board  
  attr_accessor :Jogo_Tipo
  attr_accessor :Jogo_Level
 
  TAG_JOGADOR_1 = "O" # the user's marker / Player 1 #marcação do jogador 1
  TAG_JOGADOR_2 = "X" # the computer's marker / Player 2 #marcação do jogador 2
  
  def initialize(pboDebug, pobjIO, pinTipoJogo = 1, pinNivelDificuldade = 2)
    @debug = pboDebug #permite exibir mensagens para o desenvolvedor quando ativado
    @io = pobjIO      #classe para saída e entrada de informações com o usuário
    raise ArgumentError, "Erro de inicialização: Parâmetro do objeto 'io' nulo é inválido", "board.initialize" if @io.nil?
    @slots = Tabuleiro::Slots.new(pboDebug, pobjIO, pinTipoJogo, pinNivelDificuldade)
	raise ArgumentError, "Erro de inicialização: objeto 'slots' nulo é inválido", "board.initialize" if @slots.nil?
    @Jogo_Tipo = ['Humano vs CPU', 'CPU vs CPU', 'Humano vs Humano'] #Tipos disponiveis de jogos
    @Jogo_Level = ['Fácil', 'Médio', 'Difícil'] #Nível de dificuldades da jogo/partida
    @tipo_jogo = pinTipoJogo #Indice escolhido pelo usuário
    @nivel_dificuldade = pinNivelDificuldade #Nível de dificuldade escolhida pelo usuário para jogar contra o CPU
    @vencedor = 0 #Quem venceu a partida!!! 0-velha 1-jogador1 2-jogador2
  end
  
  def Jogador1
    #marcação do jogador 1
    return TAG_JOGADOR_1 
  end
  
  def Jogador2
    #marcação do jogador 2
    return TAG_JOGADOR_2
  end
  
  def Vencedor
    #Identificador do vencedor
    return @vencedor
  end
  
  def limpa_tabuleiro
    #Limpa posições do tabuleiro e vencedor
    @slots.limpar
	@vencedor = 0
  end
    
  def print_slots_antes_de_jogar(jogador, pstMarca)
    #Exibe tabuleiro para o próximo Jogador
    @io.write "\n"
	@io.write "\nÉ a vez do Jogador #{jogador} '#{pstMarca}'" if !@slots.game_is_over() && !@slots.tudo_preenchido()
    @slots.print
	mensagem_ao_jogador
  end
    
  def getNextPlayer(pstMarca)
    #Pega a marcação oposta do jogador atual
    if (pstMarca == TAG_JOGADOR_1)
      return TAG_JOGADOR_2
    else
      return TAG_JOGADOR_1
    end    
  end
  
  def get_human_spot(pstMarca)
    spot = nil
    until spot
      spot = @io.entre_com_uma_opcao(0,8) 
      if (@slots[spot] != TAG_JOGADOR_2 && @slots[spot] != TAG_JOGADOR_1)
        @slots.set(spot, pstMarca) 
      else
        @io.write "Este Local já foi escolhido anteriormente!"
        spot = nil
      end
    end
  end
  
  def eval_board(pstMarca)
    spot = nil
	until spot
      if (@slots[4] == "4" && @nivel_dificuldade == 2) #facilitando dependendo do nivel de dificuldade     
        spot = 4
        @slots.set(spot, pstMarca)
	else
        spot = get_best_move(@slots, pstMarca, getNextPlayer(pstMarca))
		if (@slots[spot] != TAG_JOGADOR_2 && @slots[spot] != TAG_JOGADOR_1)
          @slots.set(spot, pstMarca)
		else
          spot = nil
        end
      end
    end
  end
 
  def nivel_facil(plEspacosDisponiveis) 
    #Se nivel fácil retorne um valor aleatório disponível no tabuleiro
	n = rand(0..plEspacosDisponiveis.count)
	return plEspacosDisponiveis[n].to_i
  end
  
  def nivel_medio(plEspacosDisponiveis, pinMelhorPosicao)
	@io.write "Testando sua sorte" if @debug
	posicao = pinMelhorPosicao
	if (rand(0..100) > 50) #50% de receber um movimento fácil aleatório
		@io.write "SORTE!" if @debug
		posicao = nivel_facil(plEspacosDisponiveis) #Sortiará uma posição qualquer
	else		
		@io.write "Falta de sorte =(" if @debug		
	end
	return posicao
  end
  
  def testa_antes_eficiencia_da_jogada(pSlots, pPosicao, pstMarca)
	pSlots.set(pPosicao, pstMarca)
	acabou = pSlots.game_is_over() 
	pSlots.set(pPosicao, pPosicao.to_s)	
	return acabou  #O jogo acaba com a jogada do jogador?
  end
  
  def melhor_slot(plSlots, plEspacosDisponiveis, pstMarca, next_player)
	best_slot = nil
	copia_slot = plSlots.dup
	plEspacosDisponiveis
	plEspacosDisponiveis.each do |as|
	  slots_clone = copia_slot.dup #copia atual do ultimo tabuleiro
	  if (testa_antes_eficiencia_da_jogada(slots_clone, as.to_i, pstMarca))
        return as.to_i #venci #best_slot = as.to_i
      else
	    if (testa_antes_eficiencia_da_jogada(slots_clone, as.to_i, next_player))
			best_slot = as.to_i
        end
      end
    end
	return best_slot
  end  
    
  def melhor_movimento_pelo_nivel_de_dificuldade(pinMelhor_posicao, plEspacosDisponiveis)  
	case @nivel_dificuldade 
	when 0 #Fácil!        		
		pinMelhor_posicao = nivel_facil(plEspacosDisponiveis)
	when 1 #Medio!
		pinMelhor_posicao = nivel_medio(plEspacosDisponiveis, pinMelhor_posicao)
	end
	pinMelhor_posicao = nivel_facil(plEspacosDisponiveis) if pinMelhor_posicao.nil? #se não existe melhor posicao escolha qualquer uma
	return pinMelhor_posicao
  end

  def get_best_move(poSlots, pstMarca, next_player)
	slot = poSlots.clone
	espacos_disponiveis = []
	espacos_disponiveis = slot.slots_disponiveis()
	melhor_posicao = melhor_slot(slot, espacos_disponiveis, pstMarca, next_player)
	return melhor_movimento_pelo_nivel_de_dificuldade(melhor_posicao, espacos_disponiveis)
  end

  def mensagem_ao_jogador
    if (@tipo_jogo != 1) #Se só estão jogando computadores não precisa 
      @io.write "Entre com [0-8]:"
    end
  end  
   
  def inicializa_tabuleiro
    limpa_tabuleiro
    # start by printing the board
    @slots.print
	mensagem_ao_jogador
    @vencedor = 0
  end
        
  def jogada_primeiro_jogador
	@vencedor = 1
	if (@tipo_jogo != 1)
	   get_human_spot(TAG_JOGADOR_1)
	else
	   eval_board(TAG_JOGADOR_1)
	end
  end
  
  def jogada_segundo_jogador
    @vencedor = 2
	if (@tipo_jogo != 2)
		if (@tipo_jogo == 1) #Se for CPUvsCPU exibe tabuleiro antes da jogada do 2o CPU
			print_slots_antes_de_jogar(2, TAG_JOGADOR_2)
		end
		eval_board(TAG_JOGADOR_2)
	else
		print_slots_antes_de_jogar(2, TAG_JOGADOR_2)
		get_human_spot(TAG_JOGADOR_2)
	end
  end
    
  def jogar_ate_termino_do_jogo
    until @slots.game_is_over() || @slots.tudo_preenchido()
      jogada_primeiro_jogador	  
      if !@slots.game_is_over() && !@slots.tudo_preenchido()        
		jogada_segundo_jogador
      end
      print_slots_antes_de_jogar(1, TAG_JOGADOR_1)
    end
  end
  
  def verifica_se_houve_empate
	if (@slots.tudo_preenchido() && !@slots.game_is_over())
	  @vencedor = 0
	end
  end
      
  def mensagem_termino_do_jogo  
    if (@slots.tie())
      @io.write "\nGame over - Deu velha!\n\n"
    else
      @io.write "\nGame over - Jogador #{@vencedor} Venceu!!\n\n" 
    end   
  end
  
  def start_the_game
	inicializa_tabuleiro
    jogar_ate_termino_do_jogo
	verifica_se_houve_empate
	mensagem_termino_do_jogo
	return @vencedor
  end   

end

end