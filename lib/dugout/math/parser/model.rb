module Dugout
  module Math
    module Parser
      class Model
        include Katuv::Node
        multiple PrimitiveOp
        multiple DerivedOp
      end
    end

    module Model
      def self.model(name = nil, opts={}, &block)
        Parser::Model.new(name, opts.merge(parent: nil), &block)
      end
    end
  end
end

