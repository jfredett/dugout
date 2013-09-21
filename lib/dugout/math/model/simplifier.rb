# encoding: utf-8
module Dugout
  module Math
    module Model
      class Simplifier
        def self.simplify(ast)
          new(ast).visit
        end

        def initialize(ast)
          @ast = ast
        end

        def visit

        end

        protected

        attr_reader :ast

        private
      end
    end
  end
end
