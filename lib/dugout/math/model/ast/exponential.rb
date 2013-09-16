module Dugout
  module Math
    module Model
      module AST
        define_primitive_op :Exponential do
          attribute :value

          operator 'exp'
        end
      end
    end
  end
end
