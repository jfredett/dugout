module Dugout
  module Math
    module Model
      module Expression
        module Evaluator; end
        module Language ; end
      end

      module Reifier
        def self.compile!
          Dugout::Math::Model.ops.each do |op|
            OpCompiler.new(op, Expression::Language, Expression::Evaluator).run!
          end
        end

        def self.clean!
          Dugout::Math::Model::Expression.const_set(:Evaluator, Module.new)
          Dugout::Math::Model::Expression.const_set(:Language, Module.new)
        end
      end
    end
  end
end
