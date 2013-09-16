module Dugout
  module Math
    module Model
      module Reifier
        ##
        # Compile all the consitutent classes and populate the Expression
        # namespace
        #
        # @note This will cause method caches to clear, minimize it's use for
        # optimum performance, ideally once at the start of your program
        #
        # @api private
        def self.compile!
          clean!

          Dugout::Math::Model.ops.each do |op|
            OpCompiler.new(op, Expression::Language, Expression::Evaluator).run!
          end

          Expression.define_singleton_method(:define) do |&block|
            Expression::Evaluator.instance_eval(&block)
          end
        end

        ##
        # clean out the Dugout::Math::Model namespace of the `Expression` module
        # and all it's submodules
        #
        # @note This will cause method caches to clear, minimize it's use for
        # optimum performance, ideally once at the start of your program
        #
        # @api private
        def self.clean!
          Dugout::Math::Model.send(:remove_const, :Expression) rescue nil # skirt a warning on MRI
          Dugout::Math::Model.const_set(:Expression, Module.new)
          Dugout::Math::Model::Expression.const_set(:Evaluator, Module.new)
          Dugout::Math::Model::Expression::Evaluator.const_set(:InfixOperators, Module.new)
          Dugout::Math::Model::Expression.const_set(:Language, Module.new)
        end
      end
    end
  end
end
