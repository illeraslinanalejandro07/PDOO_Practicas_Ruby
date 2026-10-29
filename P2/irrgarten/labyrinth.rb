#encoding:utf-8

require_relative 'dice'
require_relative 'directions'

module Irrgarten
    class Labyrinth
        #Atributos de clase
        @@BLOCK_CHAR = 'X'
        @@EMPTY_CHAR = '-'
        @@MONSTER_CHAR = 'M'
        @@COMBAT_CHAR = 'C'
        @@EXIT_CHAR = 'E'
        @@ROW = 0
        @@COL = 1

        #Constructor
        def initialize(n_rows, n_cols, exit_row, exit_col)
            @n_rows = n_rows
            @n_cols = n_cols
            @exit_row = exit_row
            @exit_col = exit_col

            #Tablas n_rows x n_cols (Array de Arrays)
            @monsters = Array.new(n_rows) { Array.new(n_cols) }
            @players = Array.new(n_rows) { Array.new(n_cols) }
            @labyrinth = Array.new(n_rows) { Array.new(n_cols, @@EMPTY_CHAR) }

            @labyrinth[exit_row][exit_col] = @@EXIT_CHAR
        end

        #Se implementará en la P3
        def spread_players(players)
        end

        #true si hay un jugador en la casilla de salida
        def have_a_winner
            !@players[@exit_row][@exit_col].nil?
        end

        def to_s
            @labyrinth.map { |fila| fila.join(' ') }.join("\n")
        end

        #Añade un monstruo si la posición está dentro y vacía
        def add_monster(row, col, monster)
            if pos_ok(row, col) && empty_pos(row, col)
                @labyrinth[row][col] = @@MONSTER_CHAR
                @monsters[row][col] = monster
                monster.set_pos(row, col)
            end
        end

        #Se implementará en la P3
        def put_player(direction, player)
        end

        #Se implementará en la P3
        def add_block(orientation, start_row, start_col, length)
        end

        #Se implementará en la P3
        def valid_moves(row, col)
        end

        private

        #true si la posición está dentro del laberinto
        def pos_ok(row, col)
            row >= 0 && row < @n_rows && col >= 0 && col < @n_cols
        end

        def empty_pos(row, col)
            @labyrinth[row][col] == @@EMPTY_CHAR
        end

        #Solo un monstruo (sin jugador)
        def monster_pos(row, col)
            @labyrinth[row][col] == @@MONSTER_CHAR
        end

        def exit_pos(row, col)
            @labyrinth[row][col] == @@EXIT_CHAR
        end

        #Monstruo y jugador a la vez
        def combat_pos(row, col)
            @labyrinth[row][col] == @@COMBAT_CHAR
        end

        #Dentro del laberinto y vacía, con monstruo o salida
        def can_step_on(row, col)
            pos_ok(row, col) &&
                (empty_pos(row, col) || monster_pos(row, col) || exit_pos(row, col))
        end

        #Deja en el estado correcto la casilla que abandona un jugador
        def update_old_pos(row, col)
            if pos_ok(row, col)
                if combat_pos(row, col)
                    @labyrinth[row][col] = @@MONSTER_CHAR
                else
                    @labyrinth[row][col] = @@EMPTY_CHAR
                end
            end
        end

        #Posición a la que se llega avanzando en una dirección
        def dir_2_pos(row, col, direction)
            case direction
            when Directions::LEFT  then [row, col - 1]
            when Directions::RIGHT then [row, col + 1]
            when Directions::UP    then [row - 1, col]
            when Directions::DOWN  then [row + 1, col]
            end
        end

        #Posición vacía al azar (bucle infinito si no hay ninguna)
        def random_empty_pos
            loop do
                row = Dice.random_pos(@n_rows)
                col = Dice.random_pos(@n_cols)
                return [row, col] if empty_pos(row, col)
            end
        end

        #Se implementará en la P3
        def put_player_2D(old_row, old_col, row, col, player)
        end
    end
end
