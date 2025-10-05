require 'rmagick'
require_relative 'mask_analyzer'

module Compositors
  class AdjustmentApplicator
    def initialize(mask_analyzer: MaskAnalyzer.new, threshold: Magick::QuantumRange * 0.5)
      @mask_analyzer = mask_analyzer
      @threshold = threshold
    end

    def apply(base_image:, template:, mask:, adjustment_map:)
      masked_area = @mask_analyzer.extract_area(template, mask)
      avg_brightness = @mask_analyzer.average_brightness(masked_area)

      composite_operator = avg_brightness < @threshold ? Magick::SoftLightCompositeOp : Magick::MultiplyCompositeOp

      base_image.composite(adjustment_map, Magick::NorthWestGravity, composite_operator)
    end

    private

    attr_reader :mask_analyzer
  end
end
