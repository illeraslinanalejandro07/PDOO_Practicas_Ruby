#encoding:utf-8

# Importamos archivos del módulo
require_relative 'irrgarten/directions'
require_relative 'irrgarten/orientation'
require_relative 'irrgarten/game_character'
require_relative 'irrgarten/weapon'
require_relative 'irrgarten/shield'
require_relative 'irrgarten/dice'
require_relative 'irrgarten/game_state'

module Irrgarten
  class TestP1
    def self.main
      puts "PROBANDO ENUMERADOS"
      puts "Dirección: #{Directions::LEFT}"
      puts "Orientación: #{Orientation::VERTICAL}"
      puts "Personaje: #{GameCharacter::MONSTER}"

      puts "\nPROBANDO WEAPON Y SHIELD"
      arma = Weapon.new(3.5, 2)
      escudo = Shield.new(2.5, 1)
      puts arma.to_s
      puts escudo.to_s
      
      puts "Ataque del arma: #{arma.attack}"
      puts "Defensa del escudo: #{escudo.protect}"
      
      puts "\nPROBANDO GAMESTATE"
      estado = GameState.new("Laberinto1", "Jugador1", "Monstruo1", 0, false, "El juego comienza")
      puts "Log del estado: #{estado.log}"

      puts "\nPROBANDO DADO (100 veces)"
      wins_weapons = 0
      resurrects = 0
      
      100.times do
        # Comprobar que resurrect_player ronda el 30%
        resurrects += 1 if Dice.resurrect_player
        
        # Comprobar valor de recompensa
        wins_weapons += 1 if Dice.weapons_reward == Dice::WEAPONS_REWARD
      end
      
      puts "Veces resucitado (rondaría 30): #{resurrects}"
      puts "Veces recibidas armas máximas (aleatorio pero posible): #{wins_weapons}"
      
    end
  end
end

# Ejecuta el método main automáticamente al lanzar el archivo
Irrgarten::TestP1.main
