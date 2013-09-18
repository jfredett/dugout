# encoding: utf-8
module Dugout
  module Math
    module Model
      module AST
        define_primitive_op :Log do
          attribute :value

          operator 'log'
        end
      end
    end
  end
end
