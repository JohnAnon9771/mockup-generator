require 'rmagick'

module Maps
  class LightingGenerator
    def generate(template:, mask:)
      normalized_map = template.composite(mask, Magick::CenterGravity, Magick::CopyAlphaCompositeOp)
      normalized_map.alpha(Magick::DeactivateAlphaChannel)

      lighting_map = normalized_map.modulate(0.7, 1.0, 1.0)
      lighting_map.background_color = 'grey50'
      lighting_map.alpha(Magick::RemoveAlphaChannel)

      grey_image = Magick::Image.new(lighting_map.columns, lighting_map.rows) { |img| img.background_color = 'grey50' }
      lighting_map.composite(grey_image, Magick::CenterGravity, Magick::LightenCompositeOp)
    end
  end
end
