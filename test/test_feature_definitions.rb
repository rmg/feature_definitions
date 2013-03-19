require 'helper'

class Features < FeatureDefinitions
  define_feature :AWESOME, using: [:is_awesome?] do |awesome|
    awesome
  end
end

class TestFeatureDefinitions < MiniTest::Unit::TestCase
  def test_feature_enabled
    Features.context = OpenStruct.new(is_awesome?: true)
    assert Features.AWESOME.enabled?
  end
  def test_feature_disabled
    Features.context = OpenStruct.new(is_awesome?: false)
    refute Features.AWESOME.enabled?
  end
  def test_feature_toggle
    Features.context = OpenStruct.new(is_awesome?: true)
    assert Features.AWESOME.enabled?
    Features.context = OpenStruct.new(is_awesome?: false)
    refute Features.AWESOME.enabled?
  end
  def test_feature_toggle_with_block
    Features.context = OpenStruct.new(is_awesome?: true)
    called = false
    Features.AWESOME.enabled? do
      called = true
    end
    assert called
  end
end
