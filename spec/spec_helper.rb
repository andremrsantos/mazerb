require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/reporters'
require 'mazerb'

class Module
  include Minitest::Spec::DSL
end

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]