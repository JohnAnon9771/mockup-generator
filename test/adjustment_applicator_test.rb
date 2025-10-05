require 'test_helper'

class StubMaskAnalyzer
  def initialize(average_brightness)
    @average_brightness = average_brightness
  end

  def extract_area(_template, _mask)
    :area
  end

  def average_brightness(_image)
    @average_brightness
  end
end

class RecordingImage
  attr_reader :composite_calls

  def initialize
    @composite_calls = []
  end

  def composite(map, gravity, operator)
    @composite_calls << { map: map, gravity: gravity, operator: operator }
    self
  end
end

class AdjustmentApplicatorTest < Minitest::Test
  def setup
    @adjustment_map = Magick::Image.new(2, 2)
    @threshold = Magick::QuantumRange * 0.5
  end

  def test_applies_soft_light_when_average_brightness_is_below_threshold
    mask_analyzer = StubMaskAnalyzer.new(@threshold - 1)
    applicator = Compositors::AdjustmentApplicator.new(mask_analyzer: mask_analyzer, threshold: @threshold)
    base_image = RecordingImage.new

    result = applicator.apply(
      base_image: base_image,
      template: :template,
      mask: :mask,
      adjustment_map: @adjustment_map
    )

    assert_equal base_image, result

    call = base_image.composite_calls.last
    assert_equal @adjustment_map, call[:map]
    assert_equal Magick::NorthWestGravity, call[:gravity]
    assert_equal Magick::SoftLightCompositeOp, call[:operator]
  end

  def test_applies_multiply_when_average_brightness_is_above_threshold
    mask_analyzer = StubMaskAnalyzer.new(@threshold + 1)
    applicator = Compositors::AdjustmentApplicator.new(mask_analyzer: mask_analyzer, threshold: @threshold)
    base_image = RecordingImage.new

    applicator.apply(
      base_image: base_image,
      template: :template,
      mask: :mask,
      adjustment_map: @adjustment_map
    )

    call = base_image.composite_calls.last
    assert_equal Magick::MultiplyCompositeOp, call[:operator]
  end
end
