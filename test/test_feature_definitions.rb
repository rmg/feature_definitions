require 'helper'

class TestFeatureDefinitions < MiniTest::Unit::TestCase
  def test_feature_definition
    feature_class = Class.new(FeatureDefinitions) do
      define_feature :FEATURE_NAME do |context|
        true
      end
    end
    assert feature_class.respond_to? :FEATURE_NAME
    assert feature_class.FEATURE_NAME.enabled?
  end
end

class TestFeatureDefinitionsUsage < MiniTest::Unit::TestCase
  def setup
    @feature_class = Class.new(FeatureDefinitions) do
      define_feature :AWESOME do |context|
        context.is_awesome?
      end
    end
  end
  def test_feature_enabled
    @feature_class.context = OpenStruct.new(is_awesome?: true)
    assert @feature_class.AWESOME.enabled?
  end
  def test_feature_disabled
    @feature_class.context = OpenStruct.new(is_awesome?: false)
    refute @feature_class.AWESOME.enabled?
  end
  def test_feature_toggle
    @feature_class.context = OpenStruct.new(is_awesome?: true)
    assert @feature_class.AWESOME.enabled?
    @feature_class.context = OpenStruct.new(is_awesome?: false)
    refute @feature_class.AWESOME.enabled?
  end
  def test_feature_toggle_with_block
    @feature_class.context = OpenStruct.new(is_awesome?: true)
    called = false
    @feature_class.AWESOME.enabled? do
      called = true
    end
    assert called
  end
end
