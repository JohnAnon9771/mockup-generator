require 'rmagick'
require_relative 'mask_analyzer'

module Compositors
  class MainImageBuilder
    def initialize(mask_analyzer: MaskAnalyzer.new)
      @mask_analyzer = mask_analyzer
    end

    def build(template:, mask:, artwork:, displacement_map:, lighting_map:)
      x_offset, y_offset, width, height = @mask_analyzer.bounding_box(mask)

      prepared_artwork = artwork.resize_to_fill(width, height)
      prepared_artwork = prepared_artwork.border(1, 1, 'transparent')
      prepared_artwork.alpha(Magick::RemoveAlphaChannel)

      canvas = Magick::Image.new(template.columns, template.rows) do |image|
        image.background_color = 'transparent'
      end
      canvas = canvas.composite(prepared_artwork, x_offset, y_offset, Magick::OverCompositeOp)
      canvas = canvas.displace(displacement_map, 20, 10)
      canvas.composite(lighting_map, Magick::NorthWestGravity, Magick::HardLightCompositeOp)
    end

    private

    attr_reader :mask_analyzer
  end
end
