#encoding:utf-8

require_relative 'dice'
require_relative 'player'
require_relative 'monster'
require_relative 'labyrinth'
require_relative 'game_state'
require_relative 'orientation'
require_relative 'game_character'

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
            @log = ""
            dead = @current_player.dead

            if !dead
                direction = actual_direction(preferred_direction)

                if direction != preferred_direction
                    log_player_no_orders
                end

                monster = @labyrinth.put_player(direction, @current_player)

                if monster.nil?
                    log_no_monster
                else
                    winner = combat(monster)
                    manage_reward(winner)
                end
            else
                manage_resurrection
            end

            end_game = finished

            unless end_game
                next_player
            end

            end_game
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
            current_row = @current_player.row
            current_col = @current_player.col

            valid_moves = @labyrinth.valid_moves(current_row, current_col)
            output = @current_player.move(preferred_direction, valid_moves)

            output
        end

        #Se implementará en la P3
        def combat(monster)
            rounds = 0
            winner = GameCharacter::PLAYER

            player_attack = @current_player.attack
            lose = monster.defend(player_attack)

            while !lose && rounds < @@MAX_ROUNDS
                winner = GameCharacter::MONSTER
                rounds += 1

                monster_attack = monster.attack
                lose = @current_player.defend(monster_attack)

                if !lose
                    player_attack = @current_player.attack
                    winner = GameCharacter::PLAYER
                    lose = monster.defend(player_attack)
                end
            end

            log_rounds(rounds, @@MAX_ROUNDS)
            winner
        end

        #Se implementará en la P3
        def manage_reward(winner)
            if winner == GameCharacter::PLAYER
                @current_player.receive_reward
                log_player_won
            else
                log_monster_won
            end
        end

        #Se implementará en la P3
        def manage_resurrection
            resurrect = Dice.resurrect_player

            if resurrect
                @current_player.resurrect
                log_resurrected
            else
                log_player_skip_turn
            end
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
