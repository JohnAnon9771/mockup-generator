require 'test_helper'
require 'tempfile'

class TemplateLoaderTest < Minitest::Test
  def setup
    @loader = Loaders::TemplateLoader.new
    @template_file = Tempfile.new(['template', '.png'])
    @mask_file = Tempfile.new(['mask', '.png'])
    @artwork_file = Tempfile.new(['artwork', '.png'])

    Magick::Image.new(5, 5) { |img| img.background_color = 'white' }.write(@template_file.path)
    Magick::Image.new(5, 5) { |img| img.background_color = 'black' }.write(@mask_file.path)
    Magick::Image.new(5, 5) { |img| img.background_color = 'red' }.write(@artwork_file.path)
  end

  def teardown
    [@template_file, @mask_file, @artwork_file].each do |file|
      file.close
      file.unlink
    end
  end

  def test_loads_template_mask_and_artwork
    result = @loader.load(
      template_path: @template_file.path,
      mask_path: @mask_file.path,
      artwork_path: @artwork_file.path
    )

    assert_instance_of Magick::Image, result[:template]
    assert_instance_of Magick::Image, result[:mask]
    assert_instance_of Magick::Image, result[:artwork]

    assert_equal 5, result[:template].columns
    assert_equal 5, result[:mask].rows
    assert_equal 5, result[:artwork].columns
  end
end
