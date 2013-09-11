module Dugout
  module Math
    module Model
      module Reifier
        def self.define_primitive_ops!
          Dugout::Math::Model.primitive_ops.map do |op|
            PrimitiveOpCompiler.new(op).run!
          end
        end

        def self.define_derived_ops!
          Dugout::Math::Model.derived_ops.map do |op|
            DerivedOpCompiler.new(op).run!
          end
        end

        def self.define_expression_parser!
        end

        def self.compile!
          define_primitive_ops!
          define_derived_ops!

          define_expression_parser!
        end
      end


      class DerivedOpCompiler
        attr_reader :location, :ast

        def initialize(ast, location = Dugout::Math::Model)
          @ast = ast
          @location = location
        end

        def run!
          location.const_set(ast.name, Class.new do

          end)
        end
      end
    end
  end
end
