# frozen_string_literal: true

require 'yaml'
require_relative 'game/host'
require_relative 'game/paper'
require_relative 'game/player'

# This controls gameplay
class Game
  attr_reader :player, :paper, :host, :round, :saved

  def initialize(player, paper, host, round = 1, saved: false)
    @player = player
    @paper = paper
    @host = host
    @round = round
    @saved = saved
  end

  def serialize(filename)
    Dir.mkdir('.saves') unless Dir.exist?('.saves')

    File.open(".saves/#{filename}.yaml", 'w') do |file|
      file.puts YAML.dump(self)
    end
  end

  def save
    player.guessed.pop

    @saved = true

    sleep 1

    print "\nEnter a name so you can identify and reload it later: "
    filename = gets.chomp

    serialize(filename)

    puts "\nProgress saved to \"#{filename}\""
  end

  def announce_result
    if player.won
      puts paper

      puts "\nYou got it!"
    else
      puts "\nNot this time, I'm afraid..."

      host.reveal_word
    end
  end

  def setup
    if self.saved
      @saved = false
    else
      host.choose_secret_word
    end
  end

  def player_turn
    host.show_guesses_remaining if player.misses_left < 8

    puts paper

    host.show_misses unless host.player_misses.empty?

    player.make_guess

    save if player.guessed.last.eql?('save')
  end

  def end_round
    announce_result unless @saved

    sleep 1
  end

  def play_round
    setup

    until player.misses_left.negative? || player.won
      puts "\n#############################################"

      puts "(To save your progress, enter \"save\")\n\n"

      player_turn

      break if saved

      host.give_feedback
    end

    end_round
  end

  def reset_game
    host.reset

    player.reset

    paper.reset
  end

  def quit?
    puts "\n\nWould you like to play again? (y/n)"
    answer = gets.chomp.downcase

    unless answer.eql? 'y'
      puts "Thanks for playing. Goodbye!"
      return true
    end

    false
  end

  def play
    while true
      puts "\n--- ROUND #{@round} ---"

      play_round

      break if self.saved or quit?

      reset_game

      @round = @round.next
    end
  end

  def self.reload(progress)
    previous = YAML.load(progress, 
                         permitted_classes: [Game, Host, Player, Paper], 
                         aliases: true)

    self.new(previous.player, previous.paper, previous.host, 
             round = previous.round, saved: previous.saved)
  end
end
