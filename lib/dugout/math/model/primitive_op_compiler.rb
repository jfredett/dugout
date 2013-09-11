module Dugout
  module Math
    module Model
      class PrimitiveOpCompiler
        attr_reader :location, :ast

        extend Forwardable

        delegate [:name, :attributes] => :ast
        def_delegator :attributes, :length, :arity

        def each_attribute_by_name
          attributes.each do |attr|
            yield attr.name, attr if block_given?
          end
        end

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
              args.zip(compiler.attributes).each do |arg, attr|
                instance_variable_set("@#{attr.name}", arg)
              end
            end

            compiler.each_attribute_by_name do |name|
              define_method(name) do
                instance_variable_get("@#{name}")
              end
            end
          end
        end
      end
    end
  end
end
