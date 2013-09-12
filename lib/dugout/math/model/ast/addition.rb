module Dugout
  module Math
    module Model
      module AST
        define_primitive_op :Addition do
          attribute :left
          attribute :right

          operator '+'
        end
      end
    end
  end
end
