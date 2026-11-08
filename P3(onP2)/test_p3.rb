#encoding:utf-8

require_relative 'irrgarten/directions'
require_relative 'irrgarten/orientation'
require_relative 'irrgarten/game_character'
require_relative 'irrgarten/weapon'
require_relative 'irrgarten/shield'
require_relative 'irrgarten/dice'
require_relative 'irrgarten/game_state'
require_relative 'irrgarten/monster'
require_relative 'irrgarten/player'
require_relative 'irrgarten/labyrinth'
require_relative 'irrgarten/game'

module Irrgarten
  class TestP2
    def self.main
      # ===================== MONSTER =====================
      puts "===== MONSTER ====="
      m = Monster.new("Goblin", 5.0, 4.0)
      puts m                               # posición (-1,-1): no está en el laberinto
      m.set_pos(2, 3)
      puts m
      puts "ataque (en [0,4[): #{m.attack}"
      puts "¿muerto?: #{m.dead}"
      5.times { m.send(:got_wounded) }     # got_wounded es privado: lo llamamos con send
      puts "tras 5 heridas: #{m} ¿muerto?: #{m.dead}"

      # ===================== PLAYER =====================
      puts "\n===== PLAYER ====="
      p = Player.new(0, 6.0, 3.0)
      puts p
      p.set_pos(1, 1)
      puts "fila #{p.row}, columna #{p.col}, número #{p.number}"
      puts "ataque sin armas (3.0): #{p.attack}"

      # Le damos armas y escudos a mano para probar las sumas
      p.instance_variable_set(:@weapons, [Weapon.new(2.0, 1), Weapon.new(1.0, 5)])
      p.instance_variable_set(:@shields, [Shield.new(1.5, 2)])
      puts p
      puts "ataque con armas (3+2+1 = 6.0): #{p.attack}"
      puts "ataque otra vez (3+0+1 = 4.0): #{p.attack}"
      puts "energía defensiva (6+1.5 = 7.5): #{p.send(:defensive_energy)}"
      puts "arma nueva: #{p.send(:new_weapon)}  escudo nuevo: #{p.send(:new_shield)}"

      p.send(:inc_consecutive_hits)
      p.send(:inc_consecutive_hits)
      p.send(:got_wounded)
      puts "tras 2 impactos y 1 herida: #{p}"
      p.send(:reset_hits)
      puts "tras reset_hits: #{p}"
      10.times { p.send(:got_wounded) }
      puts "¿muerto?: #{p.dead}"
      p.resurrect
      puts "tras resucitar: #{p} ¿muerto?: #{p.dead}"

      # ===================== LABYRINTH =====================
      puts "\n===== LABYRINTH ====="
      lab = Labyrinth.new(4, 5, 3, 4)
      puts lab
      lab.add_monster(1, 2, Monster.new("Orco", 1.0, 1.0))
      lab.add_monster(9, 9, Monster.new("Fuera", 1.0, 1.0))   # fuera: no se añade
      lab.add_monster(3, 4, Monster.new("Salida", 1.0, 1.0))  # salida no vacía: no se añade
      puts "\ntras añadir monstruos:\n#{lab}"

      puts "pos_ok(0,0) true: #{lab.send(:pos_ok, 0, 0)}  pos_ok(4,0) false: #{lab.send(:pos_ok, 4, 0)}"
      puts "empty_pos(0,0) true: #{lab.send(:empty_pos, 0, 0)}"
      puts "monster_pos(1,2) true: #{lab.send(:monster_pos, 1, 2)}"
      puts "exit_pos(3,4) true: #{lab.send(:exit_pos, 3, 4)}"
      puts "can_step_on(1,2) true: #{lab.send(:can_step_on, 1, 2)}  (9,9) false: #{lab.send(:can_step_on, 9, 9)}"
      puts "dir_2_pos(2,2): LEFT #{lab.send(:dir_2_pos, 2, 2, Directions::LEFT)} " +
           "RIGHT #{lab.send(:dir_2_pos, 2, 2, Directions::RIGHT)} " +
           "UP #{lab.send(:dir_2_pos, 2, 2, Directions::UP)} " +
           "DOWN #{lab.send(:dir_2_pos, 2, 2, Directions::DOWN)}"
      puts "random_empty_pos: #{lab.send(:random_empty_pos)}"

      # Simulamos un combate en (1,2) y que el jugador se va
      lab.instance_variable_get(:@labyrinth)[1][2] = 'C'
      puts "combat_pos(1,2) true: #{lab.send(:combat_pos, 1, 2)}"
      lab.send(:update_old_pos, 1, 2)
      puts "tras update_old_pos(1,2) vuelve a M: #{lab.send(:monster_pos, 1, 2)}"

      puts "¿hay ganador? (false): #{lab.have_a_winner}"
      lab.instance_variable_get(:@players)[3][4] = p
      puts "con un jugador en la salida (true): #{lab.have_a_winner}"

      # ===================== GAME =====================
      puts "\n===== GAME ====="
      game = Game.new(2)
      game.send(:log_player_won)
      game.send(:log_monster_won)
      game.send(:log_resurrected)
      game.send(:log_player_skip_turn)
      game.send(:log_player_no_orders)
      game.send(:log_no_monster)
      game.send(:log_rounds, 3, 10)

      gs = game.game_state
      puts "Laberinto:\n#{gs.labyrinth}"
      puts "Jugadores:\n#{gs.players}"
      puts "Monstruos:\n#{gs.monsters}"
      puts "Jugador actual: #{gs.current_player}"
      game.send(:next_player)
      puts "Tras next_player: #{game.game_state.current_player}"
      puts "¿Terminado?: #{game.finished}"
      puts "Log:\n#{gs.log}"
    end
  end
end

Irrgarten::TestP2.main
