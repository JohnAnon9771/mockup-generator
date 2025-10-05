require 'rmagick'

module Compositors
  class MaskAnalyzer
    def bounding_box(mask)
      trimmed = mask.trim

      [trimmed.page.x, trimmed.page.y, trimmed.columns, trimmed.rows]
    end

    def extract_area(template, mask)
      template_copy = template.copy
      mask_copy = mask.copy

      template_copy.alpha(Magick::ActivateAlphaChannel)

      mask_copy = mask_copy.quantize(256, Magick::GRAYColorspace)
      mask_copy.alpha(Magick::DeactivateAlphaChannel)

      template_copy.composite(mask_copy, Magick::NorthWestGravity, Magick::CopyAlphaCompositeOp).trim
    end

    def average_brightness(image)
      grayscale_image = image.quantize(256, Magick::GRAYColorspace)
      pixels = grayscale_image.get_pixels(0, 0, grayscale_image.columns, grayscale_image.rows)

      total_brightness = 0
      total_pixels = 0

      pixels.each do |pixel|
        next if pixel.alpha == Magick::QuantumRange

        total_brightness += pixel.red
        total_pixels += 1
      end

      return Magick::QuantumRange / 2 if total_pixels.zero?

      total_brightness / total_pixels
    end
  end
end
