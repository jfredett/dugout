module Dugout
  module Math
    class Differentiator
      def self.of(ast)
        new(ast)
      end

      attr_reader :ast, :vars
      def initialize(ast)
        @ast = ast
      end

      def with_respect_to(*syms)
        @vars = syms.map { |sym| Var.new(sym) }
        self.result
      end

      def result
        raise if vars.empty?
        derivative_of(ast)
      end

      def var(node)
        if vars.include? node
          Literal.new(1)
        else
          Literal.new(0)
        end
      end

      def literal(_)
        Literal.new(0)
      end

      def power(node)
        left, right = node.left, node.right

        right * (left ** (right - Literal.new(1))) * derivative_of(left)
      end

      def log(node)
        (1 / node.value) * derivative_of(node.value)
      end

      def add(node)
        derivative_of(node.left) + derivative_of(node.right)
      end

      def exp(node)
        dervative_of(node) * node
      end

      def multiply(node)
        (derivative_of(node) * right) + (left * derivative_of(node))
      end

      def derivative_of(ast)
        ast.visit(self)
      end

    end
  end
end
