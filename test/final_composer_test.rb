require 'test_helper'

class FinalComposerTest < Minitest::Test
  def setup
    @composer = Compositors::FinalComposer.new
    @template = Magick::Image.new(12, 12) { |img| img.background_color = 'gray40' }
    @mask = Magick::Image.new(12, 12) { |img| img.background_color = 'transparent' }
    draw = Magick::Draw.new
    draw.fill('white')
    draw.rectangle(3, 3, 8, 9)
    draw.draw(@mask)
    @artwork = Magick::Image.new(6, 8) { |img| img.background_color = 'blue' }
    @adjustment_map = Maps::AdjustmentGenerator.new.generate(template: @template, mask: @mask)
    @displacement_map = Maps::DisplacementGenerator.new.generate(template: @template, mask: @mask)
    @lighting_map = Maps::LightingGenerator.new.generate(template: @template, mask: @mask)
  end

  def test_composes_final_image_using_generated_maps
    final_image = @composer.compose(
      template: @template,
      mask: @mask,
      artwork: @artwork,
      adjustment_map: @adjustment_map,
      displacement_map: @displacement_map,
      lighting_map: @lighting_map
    )

    assert_instance_of Magick::Image, final_image
    assert_equal @template.columns, final_image.columns
    assert_equal @template.rows, final_image.rows
  end
end
