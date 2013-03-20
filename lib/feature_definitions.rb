class FeatureDefinitions
  attr_reader :test_proc

  def self.define_feature(name, &feature_test_block)
    feature = new(&feature_test_block)
    meta_class = class << self; self end
    meta_class.__send__(:define_method, name) do |&feature_impl_block|
      if feature_impl_block.nil?
        feature
      else
        feature.enabled?(&feature_impl_block)
      end
    end
  end

  PASSTHROUGH = Proc.new { |arg| arg }

  def initialize(&block)
    if block_given?
      @test_proc = block.to_proc
    else
      @test_proc = PASSTHROUGH
    end
  end

  @@context = nil

  def self.context=(context)
    @@context = context
  end

  def context
    @@context
  end

  def enabled?(&block)
    test_proc.call(context).tap do |verdict|
      yield if verdict and block_given?
    end
  end
end
