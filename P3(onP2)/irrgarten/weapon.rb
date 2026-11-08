#encoding:utf-8

module Irrgarten
    class Weapon 
        #Constructor de clase con parametros
        def initialize(power, uses)
            @power = power
            @uses = uses
        end

        #Metodo atacar
        def attack
            if @uses > 0
                @uses -= 1
                return @power
            else
                return 0.0
            end
        end

        #Metodo toString
        def to_s
            "W[#{@power}, #{@uses}]"
        end

        #Decision de descarte
        def discard
            Dice.discard_element(@uses)
        end
    end
end