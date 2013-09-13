module Dugout
  module Math
    module Model
      ##
      # This is the model definition, however, it's loaded from other files in
      # the dugout/math/model/ast directory, so this constant should _not_ be
      # used in normal operation
      Defn = model { }

      # @return The set of all primitive ops defined by the grammar
      def self.primitive_ops
        Defn.children[Parser::PrimitiveOp]
      end

      # @return The set of all derived ops defined by the grammar
      def self.derived_ops
        Defn.children[Parser::DerivedOp]
      end

      # @return The set of all ops defined by the grammar
      def self.ops
        primitive_ops + derived_ops
      end

      module AST
        ##
        # Define a operator safely on the model, disallowing unknown op types.
        #
        # @param op_type [Symbol] the operator type to define
        # @param name [Symbol] the name of the operator
        # @param block [Proc] the definition of the operator
        # @return [nil]
        def self.define(op_type, name, &block)
          raise ArgumentError unless [:primitive_op, :derived_op].include? op_type
          Defn.send(op_type, name, &block)
        end

        ##
        # Define a primitive op safely on the model, disallowing unknown op types.
        #
        # @param name [Symbol] the name of the operator
        # @param block [Proc] the definition of the operator
        # @return [nil]
        def self.define_primitive_op(name, &block)
          define(:primitive_op, name, &block)
        end

        ##
        # Define a derived op safely on the model, disallowing unknown op types.
        #
        # @param name [Symbol] the name of the operator
        # @param block [Proc] the definition of the operator
        # @return [nil]
        def self.define_derived_op(name, &block)
          define(:derived_op, name, &block)
        end
      end
    end
  end
end
