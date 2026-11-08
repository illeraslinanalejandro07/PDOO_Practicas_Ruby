#enconding:utf-8

module Control
    class Controller

        #al controlador le paso la instancia del juego y la instancia de la vista
        def initialize(game, view)
            @game = game
            @view = view
        end

        #metodo para ejecutar el bucle de la partida
        def play
            end_of_game = false

            #mientras no se haya acabado el juego, repito
            while !end_of_game 
                #muestro el estado actual y paso el game_state
                @view.showGame(@game.game_state)

                #registro la direccion elegida por el jugador
                direction = @view.next_move

                #proceso el turno completo, con next_step muevo al jugador, y devolvera true si alguien  ha llegado al finak
                end_of_game = @game.next_step(direction)
            end

            #cuando alguien llega, muestro el estado final del tablero
            @view.showGame(@game.game_state)
        end
    end
end