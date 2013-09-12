module Dugout
  module Math
    module Model
      module AST
        define_derived_op :Subtraction do
          attribute :left
          attribute :right

          operator '-'

          implementation do
            left + (lit(-1) * right)
          end
        end
      end
    end
  end
end
