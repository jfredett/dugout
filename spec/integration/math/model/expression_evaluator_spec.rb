require 'spec_helper'

describe Dugout::Math::Model::ExpressionEvaluator do
  let(:reifier) { Dugout::Math::Model::Reifier }
  subject(:exp_eval) { Dugout::Math::Model::ExpressionEvaluator }

  def operator_for(klass)
    if op = Dugout::Math::Model.ops.detect { |op| op.name == klass }
      op.operator_name
    else
      raise "No Operator for #{klass}"
    end
  end

  context 'before compile' do
    it { should_not respond_to operator_for(:Multiplication) }
    it { should_not respond_to operator_for(:Addition)       }
    it { should_not respond_to operator_for(:Variable)       }
    it { should_not respond_to operator_for(:Literal)        }
    it { should_not respond_to operator_for(:Exponential)    }
    it { should_not respond_to operator_for(:Log)            }
    it { should_not respond_to operator_for(:Subtraction)    }
    it { should_not respond_to operator_for(:Power)          }
    it { should_not respond_to operator_for(:Sqrt)           }
  end

  context 'after compile' do
    before { reifier.compile! }

    it { should respond_to operator_for(:Multiplication) }
    it { should respond_to operator_for(:Addition)       }
    it { should respond_to operator_for(:Variable)       }
    it { should respond_to operator_for(:Literal)        }
    it { should respond_to operator_for(:Exponential)    }
    it { should respond_to operator_for(:Log)            }
    it { should respond_to operator_for(:Subtraction)    }
    it { should respond_to operator_for(:Power)          }
    it { should respond_to operator_for(:Sqrt)           }
  end
end
