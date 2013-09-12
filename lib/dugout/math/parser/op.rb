module Dugout
  module Math
    module Parser
      class Op
        include Katuv::Node

        multiple Attribute

        # the operator to use when using the fancyparser (the thing that converts from
        # 'a + b * c ** 2' => \
        # 
        # Addition.new(
        #   Variable.new(:a),
        #   Multiplication.new(
        #     Variable.new(:b),
        #     Power.new(
        #       Variable.new(:c),
        #       Literal.new(2)
        #     )
        #   )
        # )
        terminal Operator

        # defaults to:
        # normal inspect, to_s
        terminal DisplayFunction

        def attributes
          Array(children[Attribute])
        end
      end

      class PrimitiveOp < Op
        def self.name
          'primitive_op'
        end
      end

      class DerivedOp < Op
        def self.name
          'derived_op'
        end

        terminal Implementation
      end
    end
  end
end

