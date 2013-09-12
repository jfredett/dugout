module Dugout
  module Math
    module Model
      module ExpressionEvaluator; end

      module Reifier
        def self.compile!
          Dugout::Math::Model.ops.each do |op|
            OpCompiler.new(op, ExpressionLanguage, ExpressionEvaluator).run!
          end
        end

        def self.define_expression_parser!
          Dugout::Math::Model.ops.each do |op|
            ExpressionEvaluator.define_singleton_method(op.operator_name) do |*args|
              const_get(op.name).new(*args)
            end
          end
        end

        def self.compile!
          define_ops!

          define_expression_parser!
        end
      end
    end
  end
end
