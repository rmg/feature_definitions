class FeatureDefinitions
  attr_reader :test_proc

  def self.define_feature(name, &feature_test_block)
    feature = new(&feature_test_block)
    meta_class = class << self; self end
    meta_class.__send__(:define_method, name) do |&feature_impl_block|
      if block_given?
        feature.enabled?(&feature_impl_block)
      end
      feature
    end
  end

  IDENTITY = Proc.new { |arg| arg }

  def initialize(&block)
    if block_given?
      @test_proc = block.to_proc
    else
      @test_proc = IDENTITY
    end
  end

  def self.context=(context)
    Thread.current[:FeatureDefinitionsTLS] = context
  end

  def context
    Thread.current[:FeatureDefinitionsTLS]
  end

  def enabled?(&block)
    eval_test_proc.tap do |verdict|
      if verdict and block_given?
        yield
      end
    end
  end

  def eval_test_proc
    if test_proc.arity == 0
      context.instance_exec(&test_proc)
    else
      test_proc.call(context)
    end
  end
end
