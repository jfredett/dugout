# encoding: utf-8
module Dugout
  module Math
    module Model
      module AST
        define_derived_op :Power do
          implementation do
            exp(log(left) * right)
          end

          operator '**'
        end
      end
    end
  end
end
