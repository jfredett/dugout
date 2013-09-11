module Dugout
  module Math
    module Model
      define_primitive_op :Addition do
        attribute :left
        attribute :right

        operator '+'
      end
    end
  end
end
