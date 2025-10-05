require 'test_helper'

class FakeImage
  attr_reader :written_path

  def write(path)
    @written_path = path
  end
end

class StubTemplateLoader
  attr_reader :calls

  def initialize(result)
    @result = result
    @calls = []
  end

  def load(args)
    @calls << args
    @result
  end
end

class StubMapGenerator
  attr_reader :calls

  def initialize(result)
    @result = result
    @calls = []
  end

  def generate(args)
    @calls << args
    @result
  end
end

class StubFinalComposer
  attr_reader :calls

  def initialize(result)
    @result = result
    @calls = []
  end

  def compose(args)
    @calls << args
    @result
  end
end

class MockupGeneratorTest < Minitest::Test
  def setup
    @template = Magick::Image.new(4, 4) { |img| img.background_color = 'gray50' }
    @mask = Magick::Image.new(4, 4) { |img| img.background_color = 'white' }
    @artwork = Magick::Image.new(4, 4) { |img| img.background_color = 'red' }

    @adjustment_map = Magick::Image.new(4, 4)
    @displacement_map = Magick::Image.new(4, 4)
    @lighting_map = Magick::Image.new(4, 4)

    @final_image = FakeImage.new

    @template_loader = StubTemplateLoader.new(template: @template, mask: @mask, artwork: @artwork)
    @adjustment_generator = StubMapGenerator.new(@adjustment_map)
    @displacement_generator = StubMapGenerator.new(@displacement_map)
    @lighting_generator = StubMapGenerator.new(@lighting_map)
    @final_composer = StubFinalComposer.new(@final_image)

    @output_dir = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry(@output_dir)
  end

  def test_orchestrates_dependencies_to_generate_mockup
    generator = MockupGenerator.new(
      'template.png',
      'mask.png',
      'artwork.png',
      output_dir: @output_dir,
      basename: 'result',
      save_intermediate: false,
      template_loader: @template_loader,
      adjustment_generator: @adjustment_generator,
      displacement_generator: @displacement_generator,
      lighting_generator: @lighting_generator,
      final_composer: @final_composer
    )

    result = generator.generate

    assert_equal @final_image, result
    assert_equal File.join(@output_dir, 'result.png'), @final_image.written_path

    load_call = @template_loader.calls.first
    assert_equal 'template.png', load_call[:template_path]
    assert_equal 'mask.png', load_call[:mask_path]
    assert_equal 'artwork.png', load_call[:artwork_path]

    @adjustment_generator.calls.each do |call|
      assert_kind_of Magick::Image, call[:template]
      assert_kind_of Magick::Image, call[:mask]
    end

    @displacement_generator.calls.each do |call|
      assert_kind_of Magick::Image, call[:template]
      assert_kind_of Magick::Image, call[:mask]
    end

    @lighting_generator.calls.each do |call|
      assert_kind_of Magick::Image, call[:template]
      assert_kind_of Magick::Image, call[:mask]
    end

    compose_call = @final_composer.calls.first
    assert_kind_of Magick::Image, compose_call[:template]
    assert_kind_of Magick::Image, compose_call[:mask]
    assert_kind_of Magick::Image, compose_call[:artwork]
    assert_equal @adjustment_map, compose_call[:adjustment_map]
    assert_equal @displacement_map, compose_call[:displacement_map]
    assert_equal @lighting_map, compose_call[:lighting_map]
  end
end
