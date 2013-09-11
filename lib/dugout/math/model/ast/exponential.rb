module Dugout
  module Math
    module Model
      define_primitive_op :Exponential do
        attribute :value

        operator 'exp'

        display_function { "exp(#{value})" }
      end
    end
  end
end

