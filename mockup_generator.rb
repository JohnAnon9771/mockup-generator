require 'rmagick'

class MockupGenerator
  def initialize(template_path, mask_path, artwork_path)
    @template = Magick::Image.read(template_path).first
    @mask = Magick::Image.read(mask_path).first
    @artwork = Magick::Image.read(artwork_path).first
  end

  def generate
    generate_adjustment_map
    generate_displacement_map
    generate_lighting_map
    generate_final_mockup
  end

  private
  def generate_adjustment_map
    grayscale_mask = @mask.quantize(256, Magick::GRAYColorspace)
    adjustment_map = @template.composite(grayscale_mask, Magick::CenterGravity, Magick::DivideSrcCompositeOp)
    adjustment_map.write('adjustment_map.jpg')
  end

  def generate_displacement_map
    mask_normalized = @mask.copy
    mask_normalized.alpha(Magick::DeactivateAlphaChannel)
    mask_normalized.colorspace = Magick::GRAYColorspace
  
    template_normalized = @template.copy
    template_normalized.alpha(Magick::DeactivateAlphaChannel)
    template_normalized.colorspace = Magick::GRAYColorspace
  
    normalized_map = template_normalized.composite(mask_normalized, Magick::CenterGravity, Magick::CopyAlphaCompositeOp)
  
    displacement_map = normalized_map.modulate(0.7, 1.0, 1.0)
    displacement_map.background_color = 'grey50'
    displacement_map.alpha(Magick::RemoveAlphaChannel)
  
    displacement_map = displacement_map.blur_image(0, 10)
  
    displacement_map.write('displacement_map.png')
  end

  def generate_lighting_map
    normalized_map = @template.composite(@mask, Magick::CenterGravity, Magick::CopyAlphaCompositeOp)
    normalized_map.alpha(Magick::DeactivateAlphaChannel)
    
    lighting_map = normalized_map.modulate(0.7, 1.0, 1.0)
    lighting_map.background_color = 'grey50'
    lighting_map.alpha(Magick::RemoveAlphaChannel)
    
    grey_image = Magick::Image.new(lighting_map.columns, lighting_map.rows) do |img|
      img.background_color = 'grey50'
    end
    lighting_map = lighting_map.composite(grey_image, Magick::CenterGravity, Magick::LightenCompositeOp)
    lighting_map.write('lighting_map.png')
  end

  def get_mask_bounding_box(mask)
    trimmed = mask.trim

    x_offset = trimmed.page.x
    y_offset = trimmed.page.y
    width = trimmed.columns
    height = trimmed.rows

    return [x_offset, y_offset, width, height]
  end

  def generate_final_mockup
    x_offset, y_offset, width, height = get_mask_bounding_box(@mask)

    main_image = @artwork.resize_to_fill(width, height)
    main_image = main_image.border(1, 1, 'transparent')
    main_image.alpha(Magick::RemoveAlphaChannel)

    main_image_with_offset = Magick::Image.new(@template.columns, @template.rows) { |image| image.background_color = 'transparent' }
    main_image_with_offset = main_image_with_offset.composite(main_image, x_offset, y_offset, Magick::OverCompositeOp)

    displacement_map = Magick::Image.read('displacement_map.png').first
    main_image_with_offset = main_image_with_offset.displace(displacement_map, 20, 20)

    lighting_map = Magick::Image.read('lighting_map.png').first
    main_image_with_offset = main_image_with_offset.composite(lighting_map, Magick::NorthWestGravity, Magick::HardLightCompositeOp)

    adjustment_map = Magick::Image.read('adjustment_map.jpg').first
    main_image_with_offset = main_image_with_offset.composite(adjustment_map, Magick::NorthWestGravity, Magick::MultiplyCompositeOp)

    masked_image = main_image_with_offset.composite(@mask, Magick::NorthWestGravity, Magick::CopyAlphaCompositeOp)
    final_image = @template.composite(masked_image, Magick::NorthWestGravity, Magick::OverCompositeOp)
    final_image.write('mockup.png')
  end
end

# Usage
template = "/Users/joaoalves/Documents/mockups/airpods/137510023_10344489.jpg"
mask = "/Users/joaoalves/Documents/mockups/airpods/137510023_10344489.png"
artwork = "/Users/joaoalves/Pictures/1369866.png"
generator = MockupGenerator.new(template, mask, artwork)
generator.generate
