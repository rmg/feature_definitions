require 'lazy_const'

class FeatureDefinitions
  extend LazyConst

  def self.define_feature(name, opts = {}, &block)
    lazy_const(name){ new(opts, &block) }
  end

  def initialize(opts = {}, &block)
    @opts = opts
    @proc = block.to_proc
  end

  def self.context=(context)
    @@context = context
  end

  def enabled?
    args = @opts[:using].map { |sym| @@context.public_send(sym) }
    @proc.call(*args)
  end

end
