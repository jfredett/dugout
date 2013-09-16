module Dugout
  module Math
    module Model
      module AST
        define_derived_op :Sqrt do
          attribute :radicand

          operator 'root'

          implementation do
            radicand ** (lit(1) / lit(2))
          end
        end
      end
    end
  end
end
