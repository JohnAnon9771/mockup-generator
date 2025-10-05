require 'rmagick'

module Maps
  class AdjustmentGenerator
    def generate(template:, mask:)
      grayscale_mask = mask.quantize(256, Magick::GRAYColorspace)
      template.composite(grayscale_mask, Magick::CenterGravity, Magick::DivideSrcCompositeOp)
    end
  end
end
