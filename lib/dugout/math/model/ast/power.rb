module Dugout
  module Math
    module Model
      define_derived_op :Power do
        implementation do
          exp(log(left) * right)
        end

        operator '**'
      end
    end
  end
end