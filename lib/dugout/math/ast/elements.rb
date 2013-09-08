module Dugout
  module Math
    class Var < UnaryNode ; end
    class Literal < UnaryNode ; end

    class Multiply < BinaryNode
      def op; '*' ; end
    end

    class Power < BinaryNode
      def op; '**'; end
    end

    class Exp < UnaryNode
      def to_s; "exp(#{value})"; end
      def name; :exp ; end
    end

    class Add < BinaryNode
      def op; '+'; end
      def name; :add; end
    end

    class Log < UnaryNode
      def to_s; "log(#{value.to_s})"; end
      def name; :log; end
    end
  end
end
