module Dugout
  module Math
    class Var < AST::UnaryNode ; end
    class Literal < AST::UnaryNode ; end

    class Multiply < AST::BinaryNode
      def op; '*' ; end
    end

    class Power < AST::BinaryNode
      def op; '**'; end
    end

    class Exp < AST::UnaryNode
      def to_s; "exp(#{value})"; end
      def name; :exp ; end
    end

    class Add < AST::BinaryNode
      def op; '+'; end
      def name; :add; end
    end

    class Log < AST::UnaryNode
      def to_s; "log(#{value.to_s})"; end
      def name; :log; end
    end
  end
end
