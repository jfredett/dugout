# encoding: utf-8
module Dugout
  module Math
    module Model
      module AST
        define_primitive_op :Literal do
          attribute :value

          operator 'lit'

          display_function { value }
        end
      end
    end
  end
end
