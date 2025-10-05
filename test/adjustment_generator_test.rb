require 'test_helper'

class AdjustmentGeneratorTest < Minitest::Test
  def setup
    @generator = Maps::AdjustmentGenerator.new
    @template = Magick::Image.new(10, 10) { |img| img.background_color = 'gray50' }
    @mask = Magick::Image.new(10, 10) { |img| img.background_color = 'white' }
    draw = Magick::Draw.new
    draw.fill('black')
    draw.rectangle(2, 2, 7, 7)
    draw.draw(@mask)
  end

  def test_generates_adjustment_map_with_template_dimensions
    adjustment_map = @generator.generate(template: @template, mask: @mask)

    assert_instance_of Magick::Image, adjustment_map
    assert_equal @template.columns, adjustment_map.columns
    assert_equal @template.rows, adjustment_map.rows
  end
end
