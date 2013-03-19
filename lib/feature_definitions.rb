require 'lazy_const'

class FeatureDefinitions
  extend LazyConst
  attr_reader :test_proc

  def self.define_feature(name, &block)
    lazy_const(name) { new(&block) }
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
