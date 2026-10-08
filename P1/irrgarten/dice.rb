#encoding:utf-8

module Irrgarten
    class Dice
        #Constantes de clase
        MAX_USES = 5
        MAX_INTELLIGENCE = 10.0
        MAX_STRENGTH = 10.0
        RESURRECT_PROB = 0.3
        WEAPONS_REWARD = 2
        SHIELDS_REWARD = 3
        HEALTH_REWARD = 5
        MAX_ATTACK = 3.0
        MAX_SHIELD = 2.0

        #Inicializo el generador de numeros aleatorios
        @generator = Random.new

        #Devuelve índice de fila o columna (0-(max-1))
        def self.random_pos(max)
            @generator.rand(max)
        end

        #Devuelve índice del jugador que empieza (0(nplayers-1))
        def self.who_starts(nplayers)
            @generator.rand(nplayers)
        end

        #Devuelve una inteligencia y fuerza (0-10.0)
        def self.random_intelligence
            @generator.rand(MAX_INTELLIGENCE)
        end

        def self.random_strength
            @generator.rand(MAX_STRENGTH)
        end

        #Devuelve la resurrecion del jugador
        def self.resurrect_player
            @generator.rand < RESURRECT_PROB
        end

        #Rewards
        def self.weapons_reward
            @generator.rand(WEAPONS_REWARD + 1)
        end

        def self.shields_reward
            @generator.rand(SHIELDS_REWARD + 1)
        end

        def self.health_reward
            @generator.rand(HEALTH_REWARD + 1)
        end

        def self.weapon_power
            @generator.rand(MAX_ATTACK)
        end

        def self.shield_power
            @generator.rand(MAX_SHIELD)
        end

        def self.uses_left
            @generator.rand(MAX_USES + 1)
        end

        def self.intensity(competence)
            @generator.rand(competence)
        end

        #Indica si descartar o no un objeto
        def self.discard_element(uses_left)
            return false if uses_left == MAX_USES
            return true if uses_left == 0

            prob_discard = (MAX_USES - uses_left).to_f / MAX_USES
            @generator.rand < prob_discard
        end
    end
end
