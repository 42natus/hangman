# frozen_string_literal: true

# This is the 'paper' that the host will draw on. It's what gets displayed.
class Paper
  attr_accessor :secret_letters

  def initialize
    @secret_letters = []
  end

  def to_s
    secret_letters.join(' ')
  end
end
