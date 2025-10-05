require 'rmagick'

module Loaders
  class TemplateLoader
    def load(template_path:, mask_path:, artwork_path:)
      {
        template: load_image(template_path),
        mask: load_image(mask_path),
        artwork: load_image(artwork_path)
      }
    end

    private

    def load_image(path)
      Magick::Image.read(path).first
    end
  end
end
