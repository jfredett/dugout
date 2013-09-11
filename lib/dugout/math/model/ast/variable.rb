module Dugout
  module Math
    module Model
      define_primitive_op :Variable do
        attribute :name

        operator 'var'

        display_function { name }
      end
    end
  end
end
