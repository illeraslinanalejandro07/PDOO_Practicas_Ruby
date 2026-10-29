#encoding:utf-8

require_relative 'dice'
require_relative 'weapon'
require_relative 'shield'

module Irrgarten
    class Player
        #Atributos de clase
        @@MAX_WEAPONS = 2
        @@MAX_SHIELDS = 3
        @@INITIAL_HEALTH = 10
        @@HITS2LOSE = 3
        @@INVALID_POS = -1   #Posición que indica que no está en ninguna casilla

        #Consultores
        attr_reader :row, :col, :number

        #Constructor
        def initialize(number, intelligence, strength)
            @number = number
            @name = "Player ##{number}"
            @intelligence = intelligence
            @strength = strength
            @health = @@INITIAL_HEALTH
            @row = @@INVALID_POS
            @col = @@INVALID_POS
            @consecutive_hits = 0
            @weapons = []
            @shields = []
        end

        #Tareas de la resurrección
        def resurrect
            @weapons = []
            @shields = []
            @health = @@INITIAL_HEALTH
            @consecutive_hits = 0
        end

        #Modificador de la posición en una sola llamada
        def set_pos(row, col)
            @row = row
            @col = col
        end

        #Indica si el jugador está muerto
        def dead
            @health <= 0
        end

        #Se implementará en la P3
        def move(direction, valid_moves)
        end

        #Fuerza más lo que aportan las armas
        def attack
            @strength + sum_weapons
        end

        #Delega en manage_hit
        def defend(received_attack)
            manage_hit(received_attack)
        end

        #Se implementará en la P3
        def receive_reward
        end

        def to_s
            "P[#{@name}, I:#{@intelligence}, S:#{@strength}, H:#{@health}, (#{@row},#{@col}), " +
            "hits:#{@consecutive_hits}, W:[#{@weapons.join(', ')}], S:[#{@shields.join(', ')}]]"
        end

        private

        #Se implementará en la P3
        def receive_weapon(w)
        end

        #Se implementará en la P3
        def receive_shield(s)
        end

        #Nueva arma con parámetros del dado
        def new_weapon
            Weapon.new(Dice.weapon_power, Dice.uses_left)
        end

        #Nuevo escudo con parámetros del dado
        def new_shield
            Shield.new(Dice.shield_power, Dice.uses_left)
        end

        #Suma de los ataques de todas sus armas
        def sum_weapons
            @weapons.sum(0.0) { |w| w.attack }
        end

        #Suma de las protecciones de todos sus escudos
        def sum_shields
            @shields.sum(0.0) { |s| s.protect }
        end

        #Inteligencia más lo que aportan los escudos
        def defensive_energy
            @intelligence + sum_shields
        end

        #Se implementará en la P3
        def manage_hit(received_attack)
        end

        def reset_hits
            @consecutive_hits = 0
        end

        def got_wounded
            @health -= 1
        end

        def inc_consecutive_hits
            @consecutive_hits += 1
        end
    end
end
