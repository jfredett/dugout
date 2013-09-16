module Dugout
  module Math
    module Model
      module Reifier
        def self.compile!
          clean!

          Dugout::Math::Model.ops.each do |op|
            OpCompiler.new(op, Expression::Language, Expression::Evaluator).run!
          end

          Expression.define_singleton_method(:define) do |&block|
            Expression::Evaluator.instance_eval(&block)
          end
        end

        def self.clean!
          Dugout::Math::Model.const_set(:Expression, Module.new)
          Dugout::Math::Model::Expression.const_set(:Evaluator, Module.new)
          Dugout::Math::Model::Expression::Evaluator.const_set(:InfixOperators, Module.new)
          Dugout::Math::Model::Expression.const_set(:Language, Module.new)
        end
      end
    end
  end
end
