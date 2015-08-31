class Scrawl
  KEY_VALUE_DELIMITER = "="
  PAIR_DELIMITER = " "
  NAMESPACE_DELIMITER = "."

  require_relative "scrawl/version"

  attr_reader :tree

  def initialize(*trees)
    @tree = trees.inject({}) { |global, tree| global.merge(tree) }
  end

  def merge(hash)
    @tree.merge!(hash.to_hash)
  end

  def inspect(namespace = nil)
    @tree.map do |key, value|
      unless value.respond_to?(:to_hash)
        label(namespace, key) + KEY_VALUE_DELIMITER + element(value)
      else
        Scrawl.new(value).inspect(key)
      end
    end.join(PAIR_DELIMITER)
  end

  def to_s(namespace = nil)
    inspect(namespace)
  end

  def to_hash
    tree.to_hash
  end

  def to_h
    tree.to_h
  end

  private def label(namespace, key)
    [namespace, key].compact.join(NAMESPACE_DELIMITER)
  end

  private def element(value)
    case value
      when Proc then element(value.call)
      when Symbol then element(value.to_s)
      else value.inspect
    end
  end
end
