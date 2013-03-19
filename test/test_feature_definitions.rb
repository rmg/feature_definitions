require 'helper'

class ConstFeatures < FeatureDefinitions
  ALWAYS_ENABLED_FEATURE = self.new { |context| true }
  ALWAYS_DISABLED_FEATURE = self.new { |context| false }
end

class TestFeatureDefinitions < MiniTest::Unit::TestCase
  def test_feature_definition_helper
    feature_class = Class.new(FeatureDefinitions) do
      define_feature :FEATURE_NAME do |context|
        true
      end
    end
    assert feature_class.respond_to? :FEATURE_NAME
    assert feature_class.FEATURE_NAME.enabled?
  end
  def test_feature_definition_constructor
    feature_class = Class.new(FeatureDefinitions)
    feature = feature_class.new { |context| true }
    assert feature.enabled?
  end
  def test_constant_feature_definitions
    assert ConstFeatures::ALWAYS_ENABLED_FEATURE.enabled?
    refute ConstFeatures::ALWAYS_DISABLED_FEATURE.enabled?
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

class TestFeatureDefaultBlock < MiniTest::Unit::TestCase
  def setup
    @feature_class = Class.new(FeatureDefinitions) do
      define_feature :AWESOME
    end
  end
  def test_feature_enabled
    @feature_class.context = true
    assert @feature_class.AWESOME.enabled?
  end
  def test_feature_disabled
    @feature_class.context = false
    refute @feature_class.AWESOME.enabled?
  end
  def test_feature_toggle
    @feature_class.context = true
    assert @feature_class.AWESOME.enabled?
    @feature_class.context = false
    refute @feature_class.AWESOME.enabled?
  end
  def test_feature_toggle_with_block
    @feature_class.context = true
    called = false
    @feature_class.AWESOME.enabled? do
      called = true
    end
    assert called
  end
end
