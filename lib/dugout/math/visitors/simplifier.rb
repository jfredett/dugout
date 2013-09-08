module Dugout
  module Math
    class Simplifier
      def self.run(ast)
        old_ast = nil
        folder = new
        new_ast = ast
        until new_ast == old_ast
          tmp     = new_ast
          new_ast = tmp.visit(folder)
          old_ast = tmp
        end
        new_ast
      end

      def lookahead(node)
        node.visit(self)
      end

      def var(node)
        node
      end

      def literal(node)
        node
      end

      def power(node)
        left = lookahead node.left
        right = lookahead node.right

        if right.is_a? Literal and right.value == 1
          return left
        end

        if left.is_a? Literal and right.is_a? Literal
          return Literal.new(left.value ** right.value)
        end

        if left.is_a? Literal and left.value == 1
          return Literal.new(1)
        end

        left ** right
      end

      def log(node)
        Log.new(lookahead(node.value))
      end

      def add(node)
        left = lookahead(node.left)
        right = lookahead(node.right)

        if left.is_a? Literal and right.is_a? Literal
          Literal.new(left.value + right.value)
        elsif left.is_a? Literal and left.value == 0
          right
        elsif right.is_a? Literal and right.value == 0
          left
        else
          left + right
        end
      end

      def exp(node)
        Exp.new(lookahead(node.value))
      end

      def multiply(node)
        left = lookahead(node.left)
        right = lookahead(node.right)

        if left.is_a? Literal and right.is_a? Literal
          Literal.new(left.value * right.value)
        elsif left.is_a? Literal and left.value == 1
          right
        elsif right.is_a? Literal and right.value == 1
          left
        elsif left.is_a? Literal and left.value == 0
          Literal.new(0)
        elsif right.is_a? Literal and right.value == 0
          Literal.new(0)
        else
          left * right
        end
      end
    end
  end
end
