#encoding:utf-8

require_relative 'control/controller.rb'
require_relative 'ui/textUI.rb'
require_relative 'irrgarten/game.rb'

module Irrgarten
    class Main
      #Defino el numero de jugadores 
      numero_jugadores = 2

      #creo una instancia del juego
      juego = Irrgarten::Game.new(numero_jugadores)

      #creo una instancia de la vista
      vista = UI::TextUI.new

      #creo el controlador 
      controlador = Control::Controller.new(juego, vista)

      #e indico que comience la partida
      controlador.play
    end
  end
end

Irrgarten::Main.new