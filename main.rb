# frozen_string_literal: true

require 'fileutils'
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

def choice_from_menu(total)
  print "\nWhich game would you like to continue? (1 to #{total})  "
  answer = gets.chomp.to_i

  until valid?(answer, total)
    puts 'Invalid option! Try again.'
    answer = gets.chomp.to_i
  end

  answer
end

def choose_save
  saves = saved_games

  puts "\nPREVIOUS GAMES"

  saves.each_with_index do |file, index|
    puts "  #{index + 1}. #{file}"
  end

  choice = choice_from_menu(saves.length)

  saves[choice - 1]
end

def new_game
  player = Player.new
  paper = Paper.new
  host = Host.new(paper, player)

  Game.new(player, paper, host)
end

def pick_game
  print "\nWould you like to load a saved game? (y/n)  "
  answer = gets.chomp.downcase

  if answer.eql?('y')
    choice = choose_save

    progress = File.read(".saves/#{choice}.yaml")

    `rm .saves/"#{choice}".yaml`

    return Game.reload(progress)
  end

  new_game
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
