#encoding:utf-8

module Irrgarten
    class Shield
        #Constructor con parametros
        def initialize(protection, uses)
            @protection = protection
            @uses = uses
        end

        #Metodo protect 
        def protect
            if @uses > 0
                @uses -= 1
                return @protection
            else
                return 0.0
            end
        end

        #Metodo toString
        def to_s
            "S[#{@protection}, #{@uses}]"
        end

        #Decision de descarte
        def discard
            Dice.discard_element(@uses)
        end
    end
end