require 'rmagick'

module Maps
  class DisplacementGenerator
    def generate(template:, mask:)
      mask_normalized = mask.copy
      mask_normalized.alpha(Magick::DeactivateAlphaChannel)
      mask_normalized.colorspace = Magick::GRAYColorspace

      template_normalized = template.copy
      template_normalized.alpha(Magick::DeactivateAlphaChannel)
      template_normalized.colorspace = Magick::GRAYColorspace

      normalized_map = template_normalized.composite(mask_normalized, Magick::CenterGravity, Magick::CopyAlphaCompositeOp)

      displacement_map = normalized_map.modulate(0.7, 1.0, 1.0)
      displacement_map.background_color = 'grey50'
      displacement_map.alpha(Magick::RemoveAlphaChannel)

      displacement_map.blur_image(0, 10)
    end
  end
end
