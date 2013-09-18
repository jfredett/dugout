# encoding: utf-8
module Dugout
  module Math
    module Model
      module AST
        define_primitive_op :Multiplication do
          attribute :left
          attribute :right

          operator '*'
        end
      end
    end
  end
end
