module Dugout
  module Math
    module Model
      ##
      # A Unit-of-work style class for turning a Parser::PrimitiveOp chunk of
      # the Model definition AST into a real expression-AST class
      class DerivedOpCompiler
        ##
        # Create a new Unit-of-work style compiler for the given chunk of the
        # model-definition AST.
        #
        # @param ast [Dugout::Math::Parser::Derived] The AST to reify into
        #     the model
        # @param location [Module] The Module on-which to define the class.
        #     Primarily used for testing purposes.
        def initialize(ast, location = Dugout::Math::Model)
          @ast = ast
          @location = location
        end

        # Cause the Operator class to be defined in Dugout::Math::Model
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

        attr_reader :location, :ast

        extend Forwardable

        delegate [:name, :attributes] => :ast
        def_delegator :attributes, :length, :arity

        ##
        # Custom iterator for dealing with attributes
        def each_attribute_by_name
          Array(attributes).each do |attr|
            yield attr.name, attr if block_given?
          end
        end
      end
    end
  end
end
