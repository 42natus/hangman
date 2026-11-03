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
  total = saves.length

  puts "\nPREVIOUS GAMES"

  saves.each_with_index do |file, index|
    puts "  #{index + 1}. #{file}"
  end

  print "\nWhich game would you like to continue? (1 to #{total})  "
  answer = gets.chomp.to_i

  until valid?(answer, total)
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

  print "\nWould you like to load a saved game? (y/n)  "
  answer = gets.chomp.downcase

  if answer.eql?('y')
    choice = choose_save

    progress = File.read(".saves/#{choice}.yaml")

    `rm .saves/"#{choice}".yaml`

    game = Game.reload(progress)
  else
    game = new_game
  end

  game
end

def saved_games?
  Dir.exist?('.saves') && !Dir.empty?('.saves')
end

def welcome
  messages = [
    '--- Welcome to HANGMAN ---',
    'I\'m your host, 42natus!',
    "Let the game begin...\n"
  ]

  messages.each do |message|
    puts message
    sleep 1
  end
end

welcome

game = saved_games? ? pick_game : new_game

game.play
