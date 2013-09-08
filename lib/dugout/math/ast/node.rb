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
          Multiply.new(self, Power.new(other, Coefficient.new(-1)))
        end

        def -(other)
          Add.new(self, Multiply.new(Coefficient.new(-1), other))
        end

        def **(other)
          Power.new(self, other)
        end

        def visit(visitor)
          visitor.send(name, self)
        end

        def arity; raise 'abstract'; end
        def unary?; raise 'abstract'; end
        def binary?; raise 'abstract'; end

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

        def arity; 2; end
        def unary?; false; end
        def binary?; true; end

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

        def arity; 1; end
        def unary?; true; end
        def binary?; false; end

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


