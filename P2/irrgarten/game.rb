#encoding:utf-8

require_relative 'dice'
require_relative 'player'
require_relative 'monster'
require_relative 'labyrinth'
require_relative 'game_state'
require_relative 'orientation'

module Irrgarten
    class Game
        #Atributos de clase
        @@MAX_ROUNDS = 10

        #Dimensiones y salida de nuestro laberinto
        @@N_ROWS = 7
        @@N_COLS = 9
        @@EXIT_ROW = 6
        @@EXIT_COL = 8

        #Constructor
        def initialize(nplayers)
            @players = []
            nplayers.times do |i|
                @players << Player.new(i, Dice.random_intelligence, Dice.random_strength)
            end

            @current_player_index = Dice.who_starts(nplayers)
            @current_player = @players[@current_player_index]

            @monsters = []
            @labyrinth = Labyrinth.new(@@N_ROWS, @@N_COLS, @@EXIT_ROW, @@EXIT_COL)
            @log = ""

            configure_labyrinth
            @labyrinth.spread_players(@players)
        end

        #Delega en el laberinto
        def finished
            @labyrinth.have_a_winner
        end

        #Se implementará en la P3
        def next_step(preferred_direction)
        end

        #Estado completo del juego
        def game_state
            GameState.new(@labyrinth.to_s,
                          @players.join("\n"),
                          @monsters.join("\n"),
                          @current_player_index,
                          finished,
                          @log)
        end

        private

        #Bloques de obstáculos y monstruos
        def configure_labyrinth
            @labyrinth.add_block(Orientation::HORIZONTAL, 1, 1, 3)
            @labyrinth.add_block(Orientation::VERTICAL, 3, 4, 3)
            @labyrinth.add_block(Orientation::HORIZONTAL, 5, 6, 2)

            [["Goblin", 0, 4], ["Orco", 3, 2], ["Troll", 4, 7]].each do |name, row, col|
                monster = Monster.new(name, Dice.random_intelligence, Dice.random_strength)
                @monsters << monster
                @labyrinth.add_monster(row, col, monster)
            end
        end

        #Pasa el turno al siguiente jugador
        def next_player
            @current_player_index = (@current_player_index + 1) % @players.size
            @current_player = @players[@current_player_index]
        end

        #Se implementará en la P3
        def actual_direction(preferred_direction)
        end

        #Se implementará en la P3
        def combat(monster)
        end

        #Se implementará en la P3
        def manage_reward(winner)
        end

        #Se implementará en la P3
        def manage_resurrection
        end

        def log_player_won
            @log += "El jugador ha ganado el combate.\n"
        end

        def log_monster_won
            @log += "El monstruo ha ganado el combate.\n"
        end

        def log_resurrected
            @log += "El jugador ha resucitado.\n"
        end

        def log_player_skip_turn
            @log += "El jugador ha perdido el turno por estar muerto.\n"
        end

        def log_player_no_orders
            @log += "El jugador no ha seguido las instrucciones del jugador humano (no fue posible).\n"
        end

        def log_no_monster
            @log += "El jugador se ha movido a una celda vacía o no le ha sido posible moverse.\n"
        end

        def log_rounds(rounds, max)
            @log += "Se han producido #{rounds} de #{max} rondas de combate.\n"
        end
    end
end
