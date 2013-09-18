# encoding: utf-8
module Dugout
  module Math
    module Model
      module AST
        define_primitive_op :Variable do
          attribute :name

          operator 'var'

          display_function { name }
        end
      end
    end
  end
end
