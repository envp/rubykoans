require File.expand_path(File.dirname(__FILE__) + '/neo')

# Implement a DiceSet Class here:
#
class DiceSet
  attr_reader :values
  Max = 6
  Min = 1
  def initialize
    @values = []
  end

  def roll(n)
    @values = []
    n.times { @values << rand(Min..Max) }
    @values
  end
end

class AboutDiceProject < Neo::Koan
  def test_can_create_a_dice_set
    dice = DiceSet.new
    assert_not_nil dice
  end

  def test_rolling_the_dice_returns_a_set_of_integers_between_1_and_6
    dice = DiceSet.new

    dice.roll(5)
    assert dice.values.is_a?(Array), "should be an array"
    assert_equal 5, dice.values.size
    dice.values.each do |value|
      assert value >= 1 && value <= 6, "value #{value} must be between 1 and 6"
    end
  end

  def test_dice_values_do_not_change_unless_explicitly_rolled
    dice = DiceSet.new
    dice.roll(5)
    first_time = dice.values
    second_time = dice.values
    assert_equal first_time, second_time
  end

  def test_dice_values_should_change_between_rolls
    dice = DiceSet.new

    dice.roll(5)
    first_time = dice.values

    dice.roll(5)
    second_time = dice.values

    assert_not_equal first_time, second_time, "Two rolls should not be equal"

    # THINK ABOUT IT:
    #
    # If the rolls are random, then it is possible (although not
    # likely) that two consecutive rolls are equal.  What would be a
    # better way to test this?

    # Don't really know
    # p_r(n) = (1/6) ** n
    # Will need some sort of stochastic testing
    # To conclude that the numbers indeed come
    # from a uniform distribution
    # Possible test: Test only single rolls for uniformity
    # Doubles, triplets etc all follow
  end

  # Custom test for uniform distribution
  def test_dice_rolls_are_part_of_a_uniform_distribution
    dice = DiceSet.new
    count = Array.new(6) {|i| 0.0}
    throw_count = 600000

    # Expected throw = 3.5 [ (1+2+3+4+5+6)/6 ]
    first_moment = 7.0/2
    second_moment = 91.0/6

    m1 = 0
    m2 = 0
    mse = 0
    throw_count.times {
      dice.roll(1)
      # Floating point hack to get ratios later
      count[dice.values[0] - 1] += 1.0
    }

    # Use a scaling factor = throw_count * expected_value
    count.map! { |c| c / throw_count }

    # First and second moments
    (1..6).each { |i| m1 += i * count[i - 1] }
    (1..6).each { |i| m2 += i * i * count[i - 1] }

    # Mean squared error
    (1..6).each { |i| mse += (count[i - 1] - 1.0/6) ** 2 }

    # Good enough if first two moments match (~99%)
    # 99.9th percentile OK
    assert_equal true, m1/first_moment > 0.99
    assert_equal true, m2/second_moment > 0.99
    assert_equal true, mse < 1e-2
  end

  def test_you_can_roll_different_numbers_of_dice
    dice = DiceSet.new

    dice.roll(3)
    assert_equal 3, dice.values.size

    dice.roll(1)
    assert_equal 1, dice.values.size
  end

end
