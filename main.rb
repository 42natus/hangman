# frozen_string_literal: true

require_relative 'lib/game'

def list_saves
  saved_games = Dir.children('.saves')

  saved_games.map! do |file|
    file.split('.').first
  end
end

def valid_entry?(answer, total)
  answer.instance_of?(Integer) && answer.between?(1, total)
end

def choose_save
  saves = list_saves

  saves.each_with_index do |file, index|
    puts "#{index + 1}. #{file}"
  end

  print "\nEnter the number of the game you'd like to continue: "
  answer = gets.chomp.to_i

  until valid_entry?(answer, saves.length)
    puts 'Invalid option! Try again.'
    answer = gets.chomp.to_i
  end

  saves[answer - 1]
end

def new_game
  player = Player.new
  paper = Paper.new
  host = Host.new(paper, player)

  Game.new(player, paper, host, 1, false)
end

def pick_game
  game = nil

  puts 'Would you like to load a saved game? (y/n)'
  answer = gets.chomp.downcase

  if answer.eql?('y')
    choice = choose_save

    yaml = File.read(".saves/#{choice}.yaml")

    game = Game.reload(yaml)
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
