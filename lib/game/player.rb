# frozen_string_literal: true

# This represents the human player. They try to guess the letters in the
# host's secret word.
class Player
  attr_reader :guess, :guesses_left
  attr_accessor :won

  def initialize
    @guess = ''
    @guesses_left = 8
    @won = false
  end

  def valid?(guess)
    guess.length == 1 && guess.between?('A', 'z')
  end

  def make_guess
    print 'Guess a letter in the word: '
    guess = gets.chomp

    until valid?(guess)
      print "You can only guess a single letter (A-Z or a-z).\nTry again: "
      guess = gets.chomp
    end

    @guesses_left -= 1
    @guess = guess.downcase
  end

  def reset
    @guess = ''
    @guesses_left = 8
    @won = false
  end
end
