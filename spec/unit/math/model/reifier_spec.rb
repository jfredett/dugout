require 'spec_helper'

describe Dugout::Math::Model::Reifier do
  subject(:reifier) { Dugout::Math::Model::Reifier }

  it { should respond_to :define_primitive_ops! }
  it { should respond_to :define_derived_ops! }
  it { should respond_to :define_expression_parser! }

  it { should respond_to :compile! }

  specify 'the following constants are undefined' do
    defined?(Dugout::Math::Model::Multiplication).should_not be
    defined?(Dugout::Math::Model::Addition).should_not be
    defined?(Dugout::Math::Model::Variable).should_not be
    defined?(Dugout::Math::Model::Literal).should_not be
    defined?(Dugout::Math::Model::Exponential).should_not be
    defined?(Dugout::Math::Model::Log).should_not be
    defined?(Dugout::Math::Model::Subtraction).should_not be
    defined?(Dugout::Math::Model::Power).should_not be
    defined?(Dugout::Math::Model::Sqrt).should_not be
  end

  context '' do
    before { reifier.compile! }

    specify 'the following constants are now defined' do
      defined?(Dugout::Math::Model::Multiplication).should be
      defined?(Dugout::Math::Model::Addition).should be
      defined?(Dugout::Math::Model::Variable).should be
      defined?(Dugout::Math::Model::Literal).should be
      defined?(Dugout::Math::Model::Exponential).should be
      defined?(Dugout::Math::Model::Log).should be
      defined?(Dugout::Math::Model::Subtraction).should be
      defined?(Dugout::Math::Model::Power).should be
      defined?(Dugout::Math::Model::Sqrt).should be
    end
  end
end

