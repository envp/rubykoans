# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#

def triangle(a, b, c)
  # Sort sides in ascending order
  a, b, c = [a, b, c].sort

  if a > 0 && b > 0 && c > 0
    # Thanks to sorting, 2/3 conditions become redundant
    if a + b > c
      if c > (a - b).abs && b > (c - a).abs && a > (b - c).abs
        if a == b && a == c
          return :equilateral
        end
        if b == c && b != a
          return :isosceles
        end
        if a != b && b != c
          return :scalene
        end
        # Alternative one-liner: return [nil, :equilateral, :isoceles, :scalene][[a,b,c].uniq.length - 1]
      else
        # (a - b).abs < c
        raise TriangleError, "Triangle Inequality: The magnitude of difference of any two sides should be smaller than the third"
      end
    else
      # a + b > c
      raise TriangleError ,"Triangle Inequality: Sum of any two sides must be larger than the third"
    end
  else
    #Non-positive sides
    raise TriangleError, "Sides must be positive"
  end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end

