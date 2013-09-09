module Dugout
  module Math
    module AST
      class Node
        def *(other)
          Multiply.new(self, other)
        end

        def +(other)
          Add.new(self, other)
        end

        def /(other)
          Multiply.new(self, Power.new(other, Literal.new(-1)))
        end

        def -(other)
          Add.new(self, Multiply.new(Literal.new(-1), other))
        end

        def **(other)
          Power.new(self, other)
        end

        def visit(visitor)
          visitor.send(name, self)
        end

        def self.arity; raise 'abstract'; end
        def self.unary?; raise 'abstract'; end
        def self.binary?; raise 'abstract'; end

        def name
          self.class.name.split('::').last.downcase.to_sym
        end

        def inspect; to_s; end
      end

      class BinaryNode < Node
        attr_reader :left, :right
        def initialize(left, right)
          @left = left
          @right = right
        end

        def self.arity; 2; end
        def self.unary?; false; end
        def self.binary?; true; end

        def to_s
          "(#{left.to_s} #{op} #{right.to_s})"
        end

        def ==(other)
          self.class == other.class &&
            left     == other.left  &&
            right    == other.right
        end
      end

      class UnaryNode < Node
        attr_reader :value
        def initialize(value)
          @value = value
        end

        def self.arity; 1; end
        def self.unary?; true; end
        def self.binary?; false; end

        def to_s
          "#{op}#{value}"
        end

        def op
          ''
        end

        def ==(other)
          self.class == other.class && value == other.value
        end
      end
    end
  end
end


