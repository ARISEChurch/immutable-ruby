require "forwardable"

module Hamster
  module Enumerable
    extend Forwardable
    include ::Enumerable

    def remove
      return enum_for(:remove) if not block_given?
      filter { |item| !yield(item) }
    end

    def compact
      filter { |item| !item.nil? }
    end

    def grep(pattern, &block)
      filter { |item| pattern === item }.map(&block)
    end

    def product
      reduce(1, &:*)
    end

    def sum
      reduce(0, &:+)
    end

    def partition
      return enum_for(:partition) if not block_given?
      a,b = super
      [self.class.new(a), self.class.new(b)].freeze
    end

    def foldr(*args, &block)
      reverse.reduce(*args, &block)
    end

    def <=>(other)
      return 0 if self.equal?(other)
      enum1, enum2 = self.to_enum, other.to_enum
      loop do
        item1 = enum1.next
        item2 = enum2.next
        comp  = (item1 <=> item2)
        return comp if comp != 0
      end
      size1, size2 = self.size, other.size
      return 0 if size1 == size2
      size1 > size2 ? 1 : -1
    end

    def_delegator :self, :each, :foreach
    def_delegator :self, :all?, :forall?
    def_delegator :self, :any?, :exist?
    def_delegator :self, :any?, :exists?
    def_delegator :self, :to_a, :to_ary
    def_delegator :self, :filter, :find_all
    def_delegator :self, :filter, :select # make it return a Hamster collection (and possibly make it lazy)
    def_delegator :self, :include?, :contains?
    def_delegator :self, :include?, :elem?
    def_delegator :self, :max, :maximum
    def_delegator :self, :min, :minimum
    def_delegator :self, :remove, :reject # make it return a Hamster collection (and possibly make it lazy)
    def_delegator :self, :remove, :delete_if
    def_delegator :self, :reduce, :fold
  end
end