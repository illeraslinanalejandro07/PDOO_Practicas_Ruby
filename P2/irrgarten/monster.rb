#encoding:utf-8

require_relative 'dice'

module Irrgarten
    class Monster
        #Atributos de clase
        @@INITIAL_HEALTH = 5
        @@INVALID_POS = -1   #Posición que indica que no está en ninguna casilla

        #Constructor
        def initialize(name, intelligence, strength)
            @name = name
            @intelligence = intelligence
            @strength = strength
            @health = @@INITIAL_HEALTH
            @row = @@INVALID_POS
            @col = @@INVALID_POS
        end

        #Indica si el monstruo está muerto
        def dead
            @health <= 0
        end

        #Intensidad del ataque según su fuerza
        def attack
            Dice.intensity(@strength)
        end

        #Se implementará en la P3
        def defend(received_attack)
        end

        #Modificador de la posición en una sola llamada
        def set_pos(row, col)
            @row = row
            @col = col
        end

        def to_s
            "M[#{@name}, I:#{@intelligence}, S:#{@strength}, H:#{@health}, (#{@row},#{@col})]"
        end

        private

        #Pierde una unidad de salud
        def got_wounded
            @health -= 1
        end
    end
end
