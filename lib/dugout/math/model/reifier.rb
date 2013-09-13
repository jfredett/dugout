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

        def self.clean!
          Dugout::Math::Model.const_set(:ExpressionEvaluator, Module.new)
          Dugout::Math::Model.const_set(:ExpressionLanguage, Module.new)
        end
      end
    end
  end
end
