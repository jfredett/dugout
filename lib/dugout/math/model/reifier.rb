module Dugout
  module Math
    module Model

      module Reifier
        def self.define_ops!
          Dugout::Math::Model.ops.map do |op|
            OpCompiler.new(op).run!
          end
        end

        def self.define_expression_parser!
        end

        def self.compile!
          define_ops!

          define_expression_parser!
        end
      end
    end
  end
end
