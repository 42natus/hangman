# frozen_string_literal: true

require 'yaml'
require_relative 'game/host'
require_relative 'game/paper'
require_relative 'game/player'

# This controls gameplay
class Game
  attr_accessor :player, :paper, :host, :round, :saved

  def initialize(player, paper, host, round, saved)
    @player = player
    @paper = paper
    @host = host
    @round = round
    @saved = saved
  end

  def serialize
    File.open('saved.yaml', 'w') do |file|
      file.puts YAML.dump(self)
    end
  end

  def save
    @player.guessed.pop

    @saved = true

    serialize

    puts "\nProgress saved"
  end

  def announce_result(player)
    if player.won
      puts @paper

      puts "\nYou got it!"
    else
      puts "\nNot this time, I'm afraid..."

      @host.reveal_word
    end
  end

  def play_round
    if @saved
      @saved = false
    else
      @host.choose_secret_word
    end

    until @player.misses_left.negative? || @player.won
      puts "\n#############################################"

      puts "(To save your progress, enter \"save\")\n\n"

      @host.show_guesses_remaining if @player.misses_left < 8
      
      puts @paper

      @host.show_misses unless @host.player_misses.empty?

      @player.make_guess

      if @player.guessed.last.eql?('save')
        save

        break
      end

      @host.give_feedback
    end

    announce_result(@player) unless @saved

    sleep 1
  end

  def welcome
    messages = [
      'Welcome to HANGMAN!', 
      'I\'m your host, 42natus!',
      "Let the game begin...\n"
    ]

    messages.each do |message|
      puts message
      sleep 1
    end
  end

  def reset_game
    @host.reset

    @player.reset

    @paper.reset
  end

  def play
    welcome

    while true
      puts "\n--- ROUND #{@round} ---"

      play_round

      break if @saved

      puts "\n\nWould you like to play again? (y/n)"
      answer = gets.chomp.downcase

      unless answer.eql? 'y'
        puts "Thanks for playing. Goodbye!"
        break
      end

      reset_game

      @round = @round.next
    end
  end

  def self.reload(yaml_string)
    previous = YAML.load(yaml_string, 
                         permitted_classes: [Game, Host, Player, Paper], 
                         aliases: true)
    self.new(previous.player, previous.paper, previous.host, previous.round, 
             previous.saved)
  end
end
