require 'rmagick'

module Compositors
  class MaskApplicator
    def apply(image:, mask:)
      image.composite(mask, Magick::NorthWestGravity, Magick::CopyAlphaCompositeOp)
    end
  end
end
