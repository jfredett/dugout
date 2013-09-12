require 'spec_helper'

describe Dugout::Math::Model::Reifier do
  subject(:reifier) { Dugout::Math::Model::Reifier }

  # clean out the namespace before compiling. This should probably
  # be a method on Math::Model
  before(:all) do
    Dugout::Math::Model::ExpressionLanguage.tap do |expression_language|
      expression_language.constants.each do |constant|
        expression_language.send(:remove_const, constant)
      end
    end
  end

  it { should respond_to :define_ops! }
  it { should respond_to :define_expression_parser! }
  it { should respond_to :compile! }

  # TODO: move this into it's own spec
  describe 'the reified expression language' do
    subject(:expression_language) { Dugout::Math::Model::ExpressionLanguage }

    its(:constants) { should be_empty }
    describe 'after compiling' do
      before { reifier.compile! }

      its(:constants) { should =~ Dugout::Math::Model.ops.map(&:name) }

    end
  end
end
