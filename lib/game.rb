# frozen_string_literal: true

require_relative 'game/host'
require_relative 'game/paper'
require_relative 'game/player'

# This controls gameplay
class Game
  def initialize
    @player = Player.new
    @paper = Paper.new
    @host = Host.new(@paper, @player)
    @round = 1
  end

  def announce_result(player)
    if player.won
      puts @paper

      puts 'You got it!'
    else
      puts 'Not this time, I\'m afraid...'

      @host.reveal_word
    end
  end

  def play_round
    @host.choose_secret_word

    until @player.misses_left.negative? || @player.won
      puts @paper

      @host.show_misses unless @host.player_misses.empty?

      @player.make_guess

      @host.give_feedback

      @host.show_guesses_remaining unless @player.correct_guess || @player.won
    end

    announce_result(@player)

    sleep 1
  end

  def welcome
    puts 'Welcome to HANGMAN!'

    sleep 1

    puts 'I\'m your host, 42natus!'

    sleep 1

    puts "Let the game begin...\n"

    sleep 1
  end

  def reset_game
    @host.reset

    @player.reset

    @paper.reset
  end

  def play
    welcome

    quit_game = false
    
    until quit_game
      puts "\nROUND #{@round}"

      play_round

      puts "\n\nWould you like to play again? (y/n)"
      answer = gets.chomp

      unless answer.eql? 'y'
        puts "Thanks for playing. Goodbye!"
        quit_game = true
      end

      reset_game

      @round = @round.next
    end
  end
end
