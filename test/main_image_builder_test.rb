require 'test_helper'

class MainImageBuilderTest < Minitest::Test
  def setup
    @mask = Magick::Image.new(12, 12) { |img| img.background_color = 'transparent' }
    draw = Magick::Draw.new
    draw.fill('white')
    draw.rectangle(4, 2, 9, 10)
    draw.draw(@mask)
    @template = Magick::Image.new(12, 12) { |img| img.background_color = 'gray30' }
    @artwork = Magick::Image.new(3, 4) { |img| img.background_color = 'red' }
    @displacement_map = Magick::Image.new(12, 12) { |img| img.background_color = 'gray50' }
    @lighting_map = Magick::Image.new(12, 12) { |img| img.background_color = 'gray60' }
    @builder = Compositors::MainImageBuilder.new
  end

  def test_build_returns_canvas_matching_template_dimensions
    canvas = @builder.build(
      template: @template,
      mask: @mask,
      artwork: @artwork,
      displacement_map: @displacement_map,
      lighting_map: @lighting_map
    )

    assert_instance_of Magick::Image, canvas
    assert_equal @template.columns, canvas.columns
    assert_equal @template.rows, canvas.rows
  end
end
