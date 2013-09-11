module Dugout
  module Math
    module Model
      class PrimitiveOpCompiler
        attr_reader :location, :ast

        extend Forwardable

        delegate [:name, :attributes] => :ast
        def_delegator :attributes, :length, :arity


        def initialize(ast, location = Dugout::Math::Model)
          @ast = ast
          @location = location
        end

        def run!
          location.const_set(ast.name, Class.new)

          compiler = self
          location.const_get(name).class_eval do
            define_method(:initialize) do |*args|
              raise ArgumentError unless args.length == compiler.arity
            end
          end
        end
      end
    end
  end
end
