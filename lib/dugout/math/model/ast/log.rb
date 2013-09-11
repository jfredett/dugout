module Dugout
  module Math
    module Model
      define_primitive_op :Log do
        attribute :value

        operator 'log'

        display_function { "log(#{value})" }
      end
    end
  end
end
