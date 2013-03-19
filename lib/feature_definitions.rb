require 'lazy_const'

class FeatureDefinitions
  extend LazyConst
  attr_reader :opts, :test_proc

  def self.define_feature(name, opts = {}, &block)
    lazy_const(name){ new(opts, block.to_proc) }
  end

  def initialize(opts, proc)
    @opts = opts
    @test_proc = proc
  end

  def self.context=(context)
    @@context = context
  end

  def context
    @@context
  end

  def enabled?(&block)
    args = opts[:using].map { |sym| context.public_send(sym) }
    test_proc.call(*args).tap do |verdict|
      yield if block_given? and verdict
    end
  end
end
