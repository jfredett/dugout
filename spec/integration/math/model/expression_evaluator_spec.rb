# encoding: utf-8
require 'spec_helper'

describe Dugout::Math::Model::Expression::Evaluator do
  let(:reifier) { Dugout::Math::Model::Reifier }
  let(:expression_namespace) { Dugout::Math::Model::Expression }
  let(:expression_language) { expression_namespace::Language }
  subject(:exp_eval) { expression_namespace::Evaluator }

  def operator_for(klass)
    if op = Dugout::Math::Model.ops.find { |o| o.name == klass }
      op.operator_name
    else
      raise "No Operator for #{klass}"
    end
  end

  context 'before compile' do
    describe 'infix operator module' do
      subject { exp_eval::InfixOperators }

      it { should_not respond_to operator_for(:Multiplication) }
      it { should_not respond_to operator_for(:Addition)       }
      it { should_not respond_to operator_for(:Variable)       }
    end

    describe 'expression evaluator' do
      subject { exp_eval }

      it { should_not respond_to operator_for(:Literal)        }
      it { should_not respond_to operator_for(:Exponential)    }
      it { should_not respond_to operator_for(:Log)            }
      it { should_not respond_to operator_for(:Subtraction)    }
      it { should_not respond_to operator_for(:Power)          }
      it { should_not respond_to operator_for(:Sqrt)           }
      it { should_not respond_to operator_for(:Derivative)  }
    end
  end

  context 'after compile' do
    before { reifier.compile! }

    describe 'infix operator module' do
      subject(:infix_operators) { exp_eval::InfixOperators }
      let(:including_class) {  Class.new {}.send(:include, infix_operators).new }

      specify { including_class.should respond_to operator_for(:Multiplication) }
      specify { including_class.should respond_to operator_for(:Addition)       }
      specify { including_class.should respond_to operator_for(:Subtraction)    }

      it { expression_language::Multiplication.ancestors.should include infix_operators }
      it { expression_language::Addition.ancestors.should include infix_operators       }
      it { expression_language::Variable.ancestors.should include infix_operators       }
    end

    describe 'expression evaluator' do
      subject { exp_eval }

      it { should respond_to operator_for(:Variable)    }
      it { should respond_to operator_for(:Literal)     }
      it { should respond_to operator_for(:Exponential) }
      it { should respond_to operator_for(:Log)         }
      it { should respond_to operator_for(:Power)       }
      it { should respond_to operator_for(:Sqrt)        }
      it { should respond_to operator_for(:Derivative)  }

      it { expression_language::Literal.ancestors.should include exp_eval::InfixOperators     }
      it { expression_language::Exponential.ancestors.should include exp_eval::InfixOperators }
      it { expression_language::Log.ancestors.should include exp_eval::InfixOperators         }
      it { expression_language::Subtraction.ancestors.should include exp_eval::InfixOperators }
      it { expression_language::Power.ancestors.should include exp_eval::InfixOperators       }
      it { expression_language::Sqrt.ancestors.should include exp_eval::InfixOperators        }
      it { expression_language::Derivative.ancestors.should include exp_eval::InfixOperators  }
    end

    describe 'after cleaning, no operators remain defined' do
      before { reifier.clean! }

      describe 'infix operator module' do
        subject { exp_eval::InfixOperators }

        it { should_not respond_to operator_for(:Multiplication) }
        it { should_not respond_to operator_for(:Addition)       }
        it { should_not respond_to operator_for(:Variable)       }
      end

      describe 'expression evaluator' do
        subject { exp_eval }

        it { should_not respond_to operator_for(:Literal)     }
        it { should_not respond_to operator_for(:Exponential) }
        it { should_not respond_to operator_for(:Log)         }
        it { should_not respond_to operator_for(:Subtraction) }
        it { should_not respond_to operator_for(:Power)       }
        it { should_not respond_to operator_for(:Sqrt)        }
        it { should_not respond_to operator_for(:Derivative)  }
      end
    end

    describe 'evaluating an expression' do
      let(:e) { expression_language }
      subject(:expression) { expression_namespace.define { log(lit(10) * x - lit(3)) } }
      let(:expected_parse_tree) do
        e::Log.new(
          e::Subtraction.new(
            e::Multiplication.new(
              e::Literal.new(10),
              e::Variable.new(:x)
            ),
            e::Literal.new(3)
          )
        )
      end

      specify { expression.should == expected_parse_tree }
    end
  end
end
