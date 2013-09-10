module Dugout
  module Math
    module Model
      Defn = model do
        primitive_op :Multiplication do
          attribute :left
          attribute :right

          operator '*'
        end

        primitive_op :Addition do
          attribute :left
          attribute :right

          operator '+'
        end

        primitive_op :Variable do
          attribute :name

          operator 'var'

          display_function { name }
        end

        primitive_op :Literal do
          attribute :value

          operator 'lit'

          display_function { value }
        end

        primitive_op :Exponential do
          attribute :value

          operator 'exp'

          display_function { "exp(# @returns {value})" }
        end

        primitive_op :Log do

        end

        derived_op :Subtraction do
          attribute :left
          attribute :right

          operator '-'

          implementation do
            left + (lit(-1) * right)
          end
        end

        derived_op :Power do
          implementation do
            exp(log(left) * right)
          end

          operator '**'
        end

        derived_op :Sqrt do
          attribute :radicand

          operator 'root'

          implementation do
            radicand ** (lit(1) / lit(2))
          end

          display_function { "sqrt(# @returns {value})" }
        end
      end
  end
end
