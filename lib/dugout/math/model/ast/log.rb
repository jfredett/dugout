module Dugout
  module Math
    module Model
      module AST
        define_primitive_op :Log do
          attribute :value

          operator 'log'

          display_function { "log(#{value})" }
        end
      end
    end
  end
end
