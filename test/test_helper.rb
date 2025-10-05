require 'minitest/autorun'
require 'minitest/pride'
require 'tmpdir'
require 'fileutils'
require 'rmagick'

$LOAD_PATH.unshift(File.expand_path('..', __dir__))

require 'mockup_generator'
require 'lib/mockup_generator/loaders/template_loader'
require 'lib/mockup_generator/maps/adjustment_generator'
require 'lib/mockup_generator/maps/displacement_generator'
require 'lib/mockup_generator/maps/lighting_generator'
require 'lib/mockup_generator/compositors/final_composer'
require 'lib/mockup_generator/compositors/main_image_builder'
require 'lib/mockup_generator/compositors/adjustment_applicator'
require 'lib/mockup_generator/compositors/mask_applicator'
require 'lib/mockup_generator/compositors/mask_analyzer'
