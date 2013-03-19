require 'lazy_const'

class FeatureDefinitions
  extend LazyConst
  attr_reader :test_proc

  def self.define_feature(name, &block)
    lazy_const(name) { new(block.to_proc) }
  end

  def initialize(proc)
    @test_proc = proc
  end

  def self.context=(context)
    @@context = context
  end

  def context
    @@context
  end

  def enabled?(&block)
    test_proc.call(context).tap do |verdict|
      yield if block_given? and verdict
    end
  end
end
