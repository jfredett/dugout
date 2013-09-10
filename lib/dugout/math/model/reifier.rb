module Dugout
  module Math
    module Model
      module Reifier
        def self.define_primitive_ops!
          Dugout::Math::Model.primitive_ops.map do |op|
            PrimitiveOpCreator.new(op).run!
          end
        end

        def self.define_derived_ops!
          Dugout::Math::Model.derived_ops.map do |op|
            DerivedOpCreator.new(op).run!
          end
        end
      end


      class DerivedOpCreator
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
