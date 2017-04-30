require_relative 'ui.rb'
require_relative 'io.rb'

module Main 
  include EntradaSaida
  include Interface

class Game
  attr_reader :ui
  attr_reader :io
  
  def initialize(pboDebug)
    @debug = pboDebug
	@io = EntradaSaida::IO.new(@debug)
    @ui = Interface::UI.new(@debug, @io)    
  end
  
  def start_game
    #iniciar Jogo da Velha
    @ui.JogarJogoDaVelha()
  end

end

end

game = Main::Game.new(true)
game.start_game

