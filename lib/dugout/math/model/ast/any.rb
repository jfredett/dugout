# encoding: utf-8
module Dugout
  module Math
    module Model
      module AST
        define_primitive_op :Any do
          attribute :klasses

          operator 'any'
        end
      end
    end
  end
end
