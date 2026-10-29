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

    until @player.guesses_left.zero? || @player.won

      puts @paper

      @player.make_guess

      @host.give_feedback

      @host.show_guesses_remaining unless @player.won
    end

    announce_result(@player)
  end
end
