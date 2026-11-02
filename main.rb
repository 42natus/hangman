# frozen_string_literal: true

require_relative 'lib/game'

def saved_games
  saves = Dir.children('.saves')

  saves.map! do |file|
    file.split('.').first
  end
end

def valid?(answer, total)
  answer.instance_of?(Integer) && answer.between?(1, total)
end

def choose_save
  saves = saved_games

  saves.each_with_index do |file, index|
    puts "#{index + 1}. #{file}"
  end

  print "\nEnter the number of the game you'd like to continue: "
  answer = gets.chomp.to_i

  until valid?(answer, saves.length)
    puts 'Invalid option! Try again.'
    answer = gets.chomp.to_i
  end

  saves[answer - 1]
end

def new_game
  player = Player.new
  paper = Paper.new
  host = Host.new(paper, player)

  Game.new(player, paper, host)
end

def pick_game
  game = nil

  puts 'Would you like to load a saved game? (y/n)'
  answer = gets.chomp.downcase

  if answer.eql?('y')
    progress = File.read(".saves/#{choose_save}.yaml")

    game = Game.reload(progress)
  else
    game = new_game
  end

  game
end

def saved_games?
  Dir.exist?('.saves') && !Dir.empty?('.saves')
end

game = saved_games? ? pick_game : new_game

game.play
