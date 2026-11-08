#encoding:utf-8

require 'io/console'
require_relative '../irrgarten/directions'

module UI
    class TextUI
        
        #Muestro estado completo del juego
        def showGame(game_state)
            puts "\n" + "="*60
            puts "                     IRRGARTEN                     "
            puts "="*60
      
            puts "\n--- LABERINTO ---"
            puts game_state.labyrinth
            
            puts "\n--- JUGADORES ---"
            puts game_state.players
            
            puts "\n--- MONSTRUOS ---"
            puts game_state.monsters
            
            puts "\n" + "-"*60
            puts "Turno del jugador: #{game_state.current_player}"
            puts "Ganador: #{game_state.winner}"
            puts "\n--- LOG DE EVENTOS ---"
            puts game_state.log
            puts "="*60
        end

        #metodo para leer desde teclado 
        def next_move
            print "\n¿Hacia dónde te mueves? [↑, ↓, ←, →]: "
            got_valid_input = false
            direction = nil

            while !got_valid_input
                #con getch me evito no tener que pulsar enter 
                c = STDIN.getch

                #cuando se pulsa la flecha del teclado, se genera una secuencia que empieza por \e
                if c == "\e"
                    begin
                        c << STDIN.read_nonblock(3)
                    rescue
                        #ignoro si no hay mas caracteres
                    end
                end

                case c
                when "\e[A", "w", "W" # flecha arriba o w
                    direction = Irrgarten::Directions::UP
                    got_valid_input = true
                when "\e[B", "s", "S" # flecha abajo o s
                    direction = Irrgarten::Directions::DOWN
                    got_valid_input = true
                when "\e[C", "d", "D" # flecha derecha o d
                    direction = Directions::RIGHT
                    got_valid_input = true
                when "\e[D", "a", "A" # flecha izquierda o a
                    direction = Directions::LEFT
                    got_valid_input = true
                else
                    puts "Entrada no válida. Por favor, use las flechas del teclado."
                end
            end

            puts "\n"
            direction
        end
    end
end