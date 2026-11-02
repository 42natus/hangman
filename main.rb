# frozen_string_literal: true

require_relative 'lib/game'

def pick_game
  game = nil

  if File.exist?('saved.yaml')
    puts 'Would you like to load a saved game? (y/n)'
    answer = gets.chomp.downcase

    if answer.eql?('y')
      game = Game.reload(File.read('saved.yaml'))
    else
      game = Game.new(Player.new, Paper.new, Host.new(@paper, @player), 1, false)
    end
  else
    game = Game.new(Player.new, Paper.new, Host.new(@paper, @player), 1, false)
  end

  game
end

game = pick_game

game.play
