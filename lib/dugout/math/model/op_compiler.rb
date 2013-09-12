module Dugout
  module Math
    module Model
      ##
      # A Unit-of-work style class for turning a Parser::PrimitiveOp chunk of
      # the Model definition AST into a real expression-AST class
      class OpCompiler
        attr_reader :location, :ast

        extend Forwardable

        delegate [:name, :attributes] => :ast
        def_delegator :attributes, :length, :arity

        ##
        # Create a new Unit-of-work style compiler for the given chunk of the
        # model-definition AST.
        #
        # @param ast [Dugout::Math::Parser::PrimitiveOp] The AST to reify into
        #     the model
        # @param location [Module] The Module on-which to define the class.
        #     Primarily used for testing purposes.
        def initialize(ast, location = Dugout::Math::Model)
          @ast = ast
          @location = location
        end

        ##
        # Custom iterator for dealing with attributes
        def each_attribute_by_name
          Array(attributes).each do |attr|
            yield attr.name, attr if block_given?
          end
        end

        ##
        # Lazily initializes the operator class in the given location
        #
        # @return [Class] the compiled op's class
        def op_class
          @op_class ||= location.const_set(ast.name, Class.new)
        end

        ##
        # Cause the Operator class to be defined in Dugout::Math::Model
        def run!
          define_initializer!
          define_attribute_getters!
          define_operator!
          define_display_functions!
        end

        def display_function
          x = ast.children[Parser::DisplayFunction]
          x.block unless x.nil?
        end

        def binary_op?
          arity == 2
        end

        def operator
          ast.children[Parser::Operator].name
        end

        private

        ##
        # Define the initializer on the compiled op's class
        def define_initializer!
          define! do |compiler|
            define_method(:initialize) do |*args|
              raise ArgumentError unless args.length == compiler.arity
              args.zip(compiler.attributes).each do |arg, attr|
                instance_variable_set("@#{attr.name}", arg)
              end
            end
          end
        end

        def define_operator!
          define! do |compiler|
            define_method(:operator) do |*args|
              compiler.operator
            end
          end
        end

        ##
        # Define each attribute's getter on the compiled op's class
        def define_attribute_getters!
          define! do |compiler|
            compiler.each_attribute_by_name do |name|
              define_method(name) { instance_variable_get("@#{name}") }
            end
          end
        end

        def define_display_functions!
          if display_function
            define! do |compiler|
              define_method(:to_s, compiler.display_function)
            end
          else
            if binary_op?
              define! do |compiler|
                define_method(:to_s) do
                  "(#{compiler.attributes.map { |i| send(i.name).to_s }.join(" #{operator} ")})"
                end
              end
            else
              define! do |compiler|
                define_method(:to_s) do
                  "#{operator}(#{compiler.attributes.map { |i| send(i.name).to_s }.join(',')})"
                end
              end
            end
          end

          define! { alias inspect to_s }
        end

        def define!(&block)
          op_class.class_exec(self, &block)
        end
      end

      ##
      # A Unit-of-work style class for turning a Parser::DerivedOp chunk of
      # the Model definition AST into a real expression-AST class
      class DerivedOpCompiler < OpCompiler
      end

      ##
      # A Unit-of-work style class for turning a Parser::PrimitiveOp chunk of
      # the Model definition AST into a real expression-AST class
      class PrimitiveOpCompiler < OpCompiler
      end
    end
  end
end
