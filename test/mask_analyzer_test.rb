require 'test_helper'

class MaskAnalyzerTest < Minitest::Test
  def setup
    @analyzer = Compositors::MaskAnalyzer.new
    @mask = Magick::Image.new(10, 10) { |img| img.background_color = 'transparent' }
    draw = Magick::Draw.new
    draw.fill('white')
    draw.rectangle(2, 3, 7, 8)
    draw.draw(@mask)
    @template = Magick::Image.new(10, 10) { |img| img.background_color = 'gray20' }
  end

  def test_bounding_box_returns_coordinates_and_dimensions
    x_offset, y_offset, width, height = @analyzer.bounding_box(@mask)

    assert_equal 2, x_offset
    assert_equal 3, y_offset
    assert_equal 6, width
    assert_equal 6, height
  end

  def test_extract_area_returns_trimmed_template_section
    extracted = @analyzer.extract_area(@template, @mask)

    assert_equal 6, extracted.columns
    assert_equal 6, extracted.rows
  end

  def test_average_brightness_for_dark_image_is_below_midpoint
    image = Magick::Image.new(2, 2) { |img| img.background_color = 'black' }

    assert_operator @analyzer.average_brightness(image), :<=, Magick::QuantumRange / 2
  end
end
