require 'test_helper'

class LightingGeneratorTest < Minitest::Test
  def setup
    @generator = Maps::LightingGenerator.new
    @template = Magick::Image.new(6, 6) { |img| img.background_color = 'gray70' }
    @mask = Magick::Image.new(6, 6) { |img| img.background_color = 'white' }
    draw = Magick::Draw.new
    draw.fill('black')
    draw.polygon(1, 1, 4, 1, 5, 5, 1, 4)
    draw.draw(@mask)
  end

  def test_generates_lighting_map_with_template_dimensions
    lighting_map = @generator.generate(template: @template, mask: @mask)

    assert_instance_of Magick::Image, lighting_map
    assert_equal @template.columns, lighting_map.columns
    assert_equal @template.rows, lighting_map.rows
  end
end
