#encoding:utf-8

module Irrgarten
    class GameState
        #Uso attr_reader para crear automaticamente getters 
        attr_reader :labyrinth, :players, :monsters, :current_player, :winner, :log

        #Constructor parametros
        def initialize(labyrinth, players, monsters, current_player, winner, log)
            @labyrinth = labyrinth
            @players = players
            @monsters = monsters
            @current_player = current_player
            @winner = winner
            @log = log
        end
    end
end