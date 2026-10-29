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
    N = 100

    def self.main
      # ===================== WEAPON =====================
      puts "===== WEAPON ====="
      w1 = Weapon.new(2.0, 5)
      w2 = Weapon.new(1.5, 1)
      w3 = Weapon.new(2.5, 0)
      puts "#{w1} #{w2} #{w3}"

      puts "w2 ataca: #{w2.attack}"   # 1.5
      puts "w2 ataca: #{w2.attack}"   # 0.0 (sin usos)
      puts "w2 tras atacar: #{w2}"    # W[1.5, 0]

      puts "w1 discard (5 usos, siempre false): #{w1.discard}"
      puts "w3 discard (0 usos, siempre true): #{w3.discard}"

      # ===================== SHIELD =====================
      puts "\n===== SHIELD ====="
      s1 = Shield.new(3.0, 4)
      s2 = Shield.new(1.0, 1)
      s3 = Shield.new(0.5, 0)
      puts "#{s1} #{s2} #{s3}"

      puts "s2 protege: #{s2.protect}"  # 1.0
      puts "s2 protege: #{s2.protect}"  # 0.0 (sin usos)
      puts "s2 tras proteger: #{s2}"    # S[1.0, 0]

      puts "s1 discard (4 usos): #{s1.discard}"
      puts "s3 discard (0 usos, siempre true): #{s3.discard}"

      # ===================== ENUMERADOS =====================
      puts "\n===== ENUMERADOS ====="
      puts "Directions: #{Directions::LEFT} #{Directions::RIGHT} #{Directions::UP} #{Directions::DOWN}"
      puts "Orientation: #{Orientation::VERTICAL} #{Orientation::HORIZONTAL}"
      puts "GameCharacter: #{GameCharacter::PLAYER} #{GameCharacter::MONSTER}"

      # ===================== GAMESTATE =====================
      puts "\n===== GAMESTATE ====="
      gs = GameState.new("laberinto", "jugadores", "monstruos", 1, false, "sin eventos")
      puts gs.labyrinth
      puts gs.players
      puts gs.monsters
      puts gs.current_player
      puts gs.winner
      puts gs.log

      # ===================== DICE (100 veces cada método) =====================
      puts "\n===== DICE ====="

      # Guardamos 100 resultados de cada método y miramos el mínimo y el máximo
      pos = Array.new(N) { Dice.random_pos(10) }
      puts "random_pos(10)       [0,9]  -> min #{pos.min}, max #{pos.max}"

      starts = Array.new(N) { Dice.who_starts(3) }
      puts "who_starts(3)        [0,2]  -> min #{starts.min}, max #{starts.max}"

      wr = Array.new(N) { Dice.weapons_reward }
      puts "weapons_reward       [0,2]  -> min #{wr.min}, max #{wr.max}"

      sr = Array.new(N) { Dice.shields_reward }
      puts "shields_reward       [0,3]  -> min #{sr.min}, max #{sr.max}"

      hr = Array.new(N) { Dice.health_reward }
      puts "health_reward        [0,5]  -> min #{hr.min}, max #{hr.max}"

      uses = Array.new(N) { Dice.uses_left }
      puts "uses_left            [0,5]  -> min #{uses.min}, max #{uses.max}"

      intel = Array.new(N) { Dice.random_intelligence }
      puts "random_intelligence  [0,10[ -> min #{intel.min}, max #{intel.max}"

      strength = Array.new(N) { Dice.random_strength }
      puts "random_strength      [0,10[ -> min #{strength.min}, max #{strength.max}"

      wp = Array.new(N) { Dice.weapon_power }
      puts "weapon_power         [0,3[  -> min #{wp.min}, max #{wp.max}"

      sp = Array.new(N) { Dice.shield_power }
      puts "shield_power         [0,2[  -> min #{sp.min}, max #{sp.max}"

      inten = Array.new(N) { Dice.intensity(5.0) }
      puts "intensity(5)         [0,5[  -> min #{inten.min}, max #{inten.max}"

      inten0 = Array.new(N) { Dice.intensity(0.0) }
      puts "intensity(0)         (0)    -> min #{inten0.min}, max #{inten0.max}"

      # Métodos que devuelven true/false: contamos cuántas veces sale true
      res = Array.new(N) { Dice.resurrect_player }.count(true)
      puts "resurrect_player      (~30): #{res} de #{N}"

      [0, 1, 4, 5].each do |u|
        desc = Array.new(N) { Dice.discard_element(u) }.count(true)
        puts "discard_element(#{u})  (esperado ~#{(5 - u) * 20}): #{desc} de #{N}"
      end
    end
  end
end

# Ejecuta el método main automáticamente al lanzar el archivo
Irrgarten::TestP1.main