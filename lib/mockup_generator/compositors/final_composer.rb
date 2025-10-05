require 'rmagick'
require_relative 'main_image_builder'
require_relative 'adjustment_applicator'
require_relative 'mask_applicator'

module Compositors
  class FinalComposer
    def initialize(main_image_builder: MainImageBuilder.new,
                   adjustment_applicator: AdjustmentApplicator.new,
                   mask_applicator: MaskApplicator.new)
      @main_image_builder = main_image_builder
      @adjustment_applicator = adjustment_applicator
      @mask_applicator = mask_applicator
    end

    def compose(template:, mask:, artwork:, adjustment_map:, displacement_map:, lighting_map:)
      main_image = @main_image_builder.build(
        template: template,
        mask: mask,
        artwork: artwork,
        displacement_map: displacement_map,
        lighting_map: lighting_map
      )

      adjusted_image = @adjustment_applicator.apply(
        base_image: main_image,
        template: template,
        mask: mask,
        adjustment_map: adjustment_map
      )

      masked_image = @mask_applicator.apply(image: adjusted_image, mask: mask)

      template.composite(masked_image, Magick::NorthWestGravity, Magick::OverCompositeOp)
    end
  end
end
