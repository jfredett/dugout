# encoding: utf-8
module Dugout
  module Math
    module Model
      ##
      # A Unit-of-work style class for turning a [Parser::PrimitiveOp] or
      # [Parser::DerivedOp] chunk of the Model definition AST into a real
      # expression-AST class
      class OpCompiler
        attr_reader :ast, :expression_namespace

        extend Forwardable
        INFIX_OPERATORS = [:+, :*, :/, :-, :'@', :'$', :!, :%, :^, :'=', :'==']

        delegate [:name, :attributes, :children] => :ast
        def_delegator :attributes, :length, :arity
        def_delegator :ast, :operator_name, :operator

        ##
        # Create a new Unit-of-work style compiler for the given chunk of the
        # model-definition AST.
        #
        # @param ast [Dugout::Math::Parser::PrimitiveOp] The AST to reify into
        #     the model
        # @param expression_namespace [Module] The namespace in which to build
        #     the op, expects that it contains a module heirarchy of the form:
        #
        #     ns -> Expression -> Language
        #                      -> Evaluator -> InfixOperators
        #
        #     you will probably never make use of this, it's primarily for
        #     testing and dependency isolation.
        def initialize(ast, expression_namespace)
          @ast = ast
          @expression_namespace = expression_namespace::Expression
        end

        ##
        # Cause the Operator class to be defined in Dugout::Math::Model
        def run!
          define_initializer!
          include_infix_operators!
          define_operator!
          define_display_functions!
          define_name!
          define_expression_evaluator_method!
          define_variable_coercion_method!
        end

        ##
        # The function the op specified to use to display it, or a default
        # calculated based on the op's arity
        #
        # @return [Proc] a proc to be used as a display function
        def display_function
          return default_display_function unless df = children[Parser::DisplayFunction]
          df.block
        end

        private

        def define_variable_coercion_method!
          expression_evaluator_location.define_singleton_method(:method_missing) do |method, *args, &block|
            return super if method == :respond_to? or respond_to? method
            var(method)
          end
        end

        ##
        # Include the InfixOperators module, so the defined op class responds to
        # all the infix operators
        def include_infix_operators!
          infix_operators = expression_evaluator_location::InfixOperators
          define! { |compiler| include infix_operators }
        end

        ##
        # Lazily initializes the operator class in the given location
        #
        # @return [Class] the compiled op's class
        def op_class
          @op_class ||= expression_language_location.const_set(name, Class.new {})
        end

        ##
        # Define the #name method on the operator class
        #
        # TODO: Write some tests for this.
        def define_name!
          define! do |compiler|
            define_method(:name) { compiler.name.downcase }
          end
        end

        ##
        # Defines an approriate method in the expression evaluator for this Op
        def define_expression_evaluator_method!
          klass = expression_language_location.const_get(name)

          if binary_op? && infix?
            # if binop, define on operator module so that everybody responds to
            # it.
            expression_evaluator_location::InfixOperators.send(:define_method, operator) do |*args|
              klass.new(self, *args)
            end
          else
            # otherwise, just define it on the expression namespace proper so
            # it's a first-class function
            expression_evaluator_location.define_singleton_method(operator) do |*args|
              klass.new(*args)
            end
          end
        end

        ##
        # @return [true] if the operator is an infix
        # @return [false] otherwise
        def infix?
          INFIX_OPERATORS.include? operator.to_sym
        end

        ##
        # The Location to define AST classes on.
        def expression_language_location
          return @expression_language_location if defined? @expression_language_location
          @expression_language_location = expression_namespace::Language
        end

        ##
        # The Location to define evaluator methods on.
        def expression_evaluator_location
          return @expression_evaluator_location if defined? @expression_evaluator_location
          @expression_evaluator_location = expression_namespace::Evaluator
        end

        ##
        # Calculates the default display function to use when none is specified
        #
        # @return [Proc] a proc to be used as a display function
        def default_display_function
          _attributes = attributes
          if binary_op? && infix?
            lambda do
              "(#{_attributes.map { |i| send(i.name).to_s }.join(" #{operator} ")})"
            end
          else
            lambda do
              "#{operator}(#{_attributes.map { |i| send(i.name).to_s }.join(',')})"
            end
          end
        end

        ##
        # true if the op is binary, false otherwise
        # @return [Boolean]
        def binary_op?
          arity == 2
        end

        ##
        # Define the initializer on the compiled op's class
        def define_initializer!
          define! do |compiler|
            include Concord::Public.new(*compiler.attributes.map { |attr| attr.name.to_sym })
          end
        end

        ##
        # Define the #operator method on the compiled class
        def define_operator!
          define! do |compiler|
            define_method(:operator) do |*args|
              compiler.operator
            end
          end
        end

        ##
        # Define #to_s and #inspect on the compiled class
        def define_display_functions!
          define! do |compiler|
            define_method(:to_s, &compiler.display_function)
          end
          define! { alias inspect to_s }
        end

        ##
        # Define an arbitrary method on the compiled class.
        #
        # @param block [Proc] a proc of arity 0 or 1, if it takes a parameter,
        #    it will be passed the OpCompiler instance.
        def define!(&block)
          op_class.class_exec(self, &block)
        end
      end
    end
  end
end
