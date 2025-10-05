require 'test_helper'

class DisplacementGeneratorTest < Minitest::Test
  def setup
    @generator = Maps::DisplacementGenerator.new
    @template = Magick::Image.new(8, 8) { |img| img.background_color = 'gray60' }
    @mask = Magick::Image.new(8, 8) { |img| img.background_color = 'white' }
    draw = Magick::Draw.new
    draw.fill('black')
    draw.circle(4, 4, 4, 0)
    draw.draw(@mask)
  end

  def test_produces_blurred_displacement_map_with_same_size
    displacement_map = @generator.generate(template: @template, mask: @mask)

    assert_instance_of Magick::Image, displacement_map
    assert_equal @template.columns, displacement_map.columns
    assert_equal @template.rows, displacement_map.rows
  end
end
