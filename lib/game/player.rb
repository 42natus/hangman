# frozen_string_literal: true

# This represents the human player. They try to guess the letters in the
# host's secret word.
class Player
  attr_reader :guess, :guessed
  attr_accessor :won, :misses_left, :correct_guess

  def initialize
    @won = false
    @guess = ''
    @guessed = []
    @misses_left = 8
    @correct_guess = true
  end

  def valid?(guess)
    guess.length == 1 && guess.between?('A', 'z') && 
    !guessed.include?(guess)
  end

  def make_guess
    print "Guess a letter in the word: "
    input = gets.chomp.downcase

    until valid?(input)
      print "You can only guess a single letter (A-Z or a-z) that you haven't \
already guessed.\nTry again: "
      input = gets.chomp.downcase
    end

    @guessed << input

    @guess = input
  end

  def reset
    @won = false
    @guess = ''
    @guessed = []
    @misses_left = 8
    @correct_guess = true
  end
end
