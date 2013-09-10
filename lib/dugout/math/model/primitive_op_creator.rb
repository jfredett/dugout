module Dugout
  module Math
    module Model
      class PrimitiveOpCreator
        attr_reader :location, :ast

        def initialize(ast, location = Dugout::Math::Model)
          @ast = ast
          @location = location
        end

        def run!
          location.const_set(ast.name, Class.new)

          creator = self
          location.const_get(ast.name).class_eval do
            define_method(:initialize) do |*args|
              raise ArgumentError unless args.length == creator.ast.attributes.length
            end
          end
        end
      end
    end
  end
end
