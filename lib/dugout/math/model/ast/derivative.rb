# encoding: utf-8
module Dugout
  module Math
    module Model
      module AST
        define_primitive_op :Derivative do
          attribute :function
          attribute :variable

          operator 'D'

          display_function do
            "D(#{function}, #{variable})"
          end
        end
      end
    end
  end
end
