class PagesController < ApplicationController
  def game
    $grid = generate_grid(rand(9..20))
    $start_time = Time.now
  end

  def score
    @score = run_game(params[:query], $grid, $start_time, Time.now)
    #params here? #how can I call my run game to this method?
  end
end

private

def generate_grid(grid_size)
  grid = Array.new(grid_size) { ("A".."Z").to_a.sample }
  return grid
end


def matches?(attempt, grid)
  attempt.chars.all? { |letter| attempt.count(letter) <= grid.count(letter) }
end


def english_word?(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  serialized_word = open(url).read
  word = JSON.parse(serialized_word)
  return word["found"]

end


def total_time(start_time, end_time)
  total_time = end_time - start_time
  return total_time
end


def run_game(attempt, grid, start_time, end_time)
  # TODO: runs the game and return detailed hash of result
  result = {}
  if english_word?(attempt)
    if matches?(attempt.upcase, grid)
      result[:message] = "Well done"
      result[:score] = ((attempt.length / total_time(start_time, end_time)) * 1000).to_i
    else
      result[:message] = "Not in the grid"
      result[:score] = 0
    end
  else
    result[:score] = 0
    result[:message] = "not an english word"
  end
  result[:time] = total_time(start_time, end_time)
  return result
end

