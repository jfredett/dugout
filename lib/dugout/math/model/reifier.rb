module Dugout
  module Math
    module Model
      module Reifier
        def self.define_primitive_ops!
          Dugout::Math::Model.primitive_ops.map do |op|
            PrimitiveOpCompiler.new(op).run!
          end
        end

        def self.define_derived_ops!
          Dugout::Math::Model.derived_ops.map do |op|
            DerivedOpCompiler.new(op).run!
          end
        end

        def self.define_expression_parser!
        end

        def self.compile!
          define_primitive_ops!
          define_derived_ops!

          define_expression_parser!
        end
      end
    end
  end
end
