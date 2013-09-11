module Dugout
  module Math
    module Model
      define_derived_op :Sqrt do
        attribute :radicand

        operator 'root'

        implementation do
          radicand ** (lit(1) / lit(2))
        end

        display_function { "sqrt(#{value})" }
      end
    end
  end
end
