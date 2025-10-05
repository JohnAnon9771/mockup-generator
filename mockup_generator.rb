require 'rmagick'
require 'fileutils'

require_relative 'lib/mockup_generator/loaders/template_loader'
require_relative 'lib/mockup_generator/maps/adjustment_generator'
require_relative 'lib/mockup_generator/maps/displacement_generator'
require_relative 'lib/mockup_generator/maps/lighting_generator'
require_relative 'lib/mockup_generator/compositors/final_composer'

class MockupGenerator
  def initialize(template_path, mask_path, artwork_path, output_dir: nil, basename: nil, save_intermediate: false,
                 template_loader: Loaders::TemplateLoader.new,
                 adjustment_generator: Maps::AdjustmentGenerator.new,
                 displacement_generator: Maps::DisplacementGenerator.new,
                 lighting_generator: Maps::LightingGenerator.new,
                 final_composer: Compositors::FinalComposer.new)
    @template_path = template_path
    @mask_path = mask_path
    @artwork_path = artwork_path

    @output_dir = output_dir || Dir.pwd
    @basename = basename || 'mockup'
    @save_intermediate = save_intermediate

    @template_loader = template_loader
    @adjustment_generator = adjustment_generator
    @displacement_generator = displacement_generator
    @lighting_generator = lighting_generator
    @final_composer = final_composer

    load_images
  end

  def generate(output_dir: nil, basename: nil, save_intermediate: nil)
    effective_output_dir = output_dir || @output_dir
    effective_basename = basename || @basename
    effective_save_intermediate = save_intermediate.nil? ? @save_intermediate : save_intermediate

    FileUtils.mkdir_p(effective_output_dir) unless Dir.exist?(effective_output_dir)

    template = @template.copy
    mask = @mask.copy
    artwork = @artwork.copy

    adjustment_map = @adjustment_generator.generate(template: template.copy, mask: mask.copy)
    displacement_map = @displacement_generator.generate(template: template.copy, mask: mask.copy)
    lighting_map = @lighting_generator.generate(template: template.copy, mask: mask.copy)

    if effective_save_intermediate
      adjustment_map.write(File.join(effective_output_dir, "#{effective_basename}_adjustment_map.jpg"))
      displacement_map.write(File.join(effective_output_dir, "#{effective_basename}_displacement_map.png"))
      lighting_map.write(File.join(effective_output_dir, "#{effective_basename}_lighting_map.png"))
    end

    final_image = @final_composer.compose(
      template: template,
      mask: mask,
      artwork: artwork,
      adjustment_map: adjustment_map,
      displacement_map: displacement_map,
      lighting_map: lighting_map
    )

    final_path = File.join(effective_output_dir, "#{effective_basename}.png")
    final_image.write(final_path)

    final_image
  end

  private

  def load_images
    images = @template_loader.load(
      template_path: @template_path,
      mask_path: @mask_path,
      artwork_path: @artwork_path
    )

    @template = images[:template]
    @mask = images[:mask]
    @artwork = images[:artwork]
  end
end
