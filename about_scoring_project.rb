require File.expand_path(File.dirname(__FILE__) + '/neo')

# Greed is a dice game where you roll up to five dice to accumulate
# points.  The following "score" function will be used to calculate the
# score of a single roll of the dice.
#
# A greed roll is scored as follows:
#
# * A set of three ones is 1000 points
#
# * A set of three numbers (other than ones) is worth 100 times the
#   number. (e.g. three fives is 500 points).
#
# * A one (that is not part of a set of three) is worth 100 points.
#
# * A five (that is not part of a set of three) is worth 50 points.
#
# * Everything else is worth 0 points.
#
#
# Examples:
#
# score([1,1,1,5,1]) => 1150 points
# score([2,3,4,6,2]) => 0 points
# score([3,4,5,3,3]) => 350 points
# score([1,5,1,2,4]) => 250 points
#
# More scoring examples are given in the tests below:
#
# Your goal is to write the score method.

# I can't think of a good name
# _({}) seems anon enough
# Thank goat, ruby koans doesn't use _ along with __
def _(opts = {})
  # Returns the Array below:
  # [score, updated_roll_count]
  # Contants
  singles_multiplier = [100, 0, 0, 0, 50, 0]
  triples_multiplier = [1000, 100, 100, 100, 100, 100]

  dice_value  = opts[:dice_value]
  roll_count  = opts[:roll_count]
  roll_index  = opts[:roll_index]
  score       = opts[:score]

  begin
    if ( opts.empty? || !(opts.is_a?(Hash)) )
      raise ArgumentException, 'No parameters supplied!'
    else
      if opts[:triples]
        [
          score + dice_value * triples_multiplier[roll_index],
          roll_count[roll_index] - 3
        ]
      elsif opts[:singles]
        [ 
          score + roll_count[roll_index] * singles_multiplier[roll_index],
          0
        ]
      else
        raise ArgumentException, 'Only singles and triples cases allowed!'
      end
    end
  rescue Exception => e
    puts "#{e.class} : #{e.message}"
  end
end
def score(dice)
  s = 0
  unless dice.empty?
    roll_count = [1, 2, 3, 4, 5, 6].map{ |r| dice.count(r) }

    # Loop over all the dice values
    dice.each do |dice_value|
      # Initialize the scoring options to be passed to _({}) later
      roll_index = dice_value - 1
      next if roll_count[roll_index].zero?

      if roll_count[roll_index] > 2
        # Triples
        s, roll_count[roll_index] = _(
          triples: true, 
          dice_value: dice_value, 
          roll_count: roll_count, 
          roll_index: roll_index, 
          score: s)
      else
        # Singles
        s, roll_count[roll_index] = _(
          singles: true, 
          dice_value: dice_value, 
          roll_count: roll_count, 
          roll_index: roll_index, 
          score: s)
      end

    end
  end
  # Return the score
  s
end

class AboutScoringProject < Neo::Koan
  def test_score_of_an_empty_list_is_zero
    assert_equal 0, score([])
  end

  def test_score_of_a_single_roll_of_5_is_50
    assert_equal 50, score([5])
  end

  def test_score_of_a_single_roll_of_1_is_100
    assert_equal 100, score([1])
  end

  def test_score_of_multiple_1s_and_5s_is_the_sum_of_individual_scores
    assert_equal 300, score([1,5,5,1])
  end

  def test_score_of_single_2s_3s_4s_and_6s_are_zero
    assert_equal 0, score([2,3,4,6])
  end

  def test_score_of_a_triple_1_is_1000
    assert_equal 1000, score([1,1,1])
  end

  def test_score_of_other_triples_is_100x
    assert_equal 200, score([2,2,2])
    assert_equal 300, score([3,3,3])
    assert_equal 400, score([4,4,4])
    assert_equal 500, score([5,5,5])
    assert_equal 600, score([6,6,6])
  end

  def test_score_of_mixed_is_sum
    assert_equal 250, score([2,5,2,2,3])
    assert_equal 550, score([5,5,5,5])
    assert_equal 1100, score([1,1,1,1])
    assert_equal 1200, score([1,1,1,1,1])
    assert_equal 1150, score([1,1,1,5,1])
    # Custom tests, 'cause I can't believe it
    assert_equal 2000, score([1,1,1,1,1,1])
    assert_equal 500, score([5,5,5,2,2,4])
  end

end
