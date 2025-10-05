require 'test_helper'

class CompositeSpy
  attr_reader :calls

  def initialize
    @calls = []
  end

  def composite(mask, gravity, operator)
    @calls << { mask: mask, gravity: gravity, operator: operator }
    :result
  end
end

class MaskApplicatorTest < Minitest::Test
  def test_apply_uses_copy_alpha_composite
    base_image = CompositeSpy.new
    mask = Magick::Image.new(2, 2)
    applicator = Compositors::MaskApplicator.new

    result = applicator.apply(image: base_image, mask: mask)

    assert_equal :result, result
    call = base_image.calls.last
    assert_equal mask, call[:mask]
    assert_equal Magick::NorthWestGravity, call[:gravity]
    assert_equal Magick::CopyAlphaCompositeOp, call[:operator]
  end
end
