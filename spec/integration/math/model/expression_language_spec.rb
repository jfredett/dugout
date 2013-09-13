require 'spec_helper'

# XXX: this is probably better described as the ExpressionLanguage spec.
# TODO: rename Expression* to Expression::* ?
describe Dugout::Math::Model::ExpressionLanguage do
  subject(:reifier) { Dugout::Math::Model::Reifier }
  let(:expression_evaluator) { Dugout::Math::Model::ExpressionEvaluator }
  let(:expression_language) { Dugout::Math::Model::ExpressionLanguage }

  describe 'the expression language' do
    before { reifier.clean! }
    subject { expression_language }

    context 'before compilation' do
      its(:constants) { should be_empty }
    end

    context 'after compilation' do
      before { reifier.compile! }
      its(:constants) { should_not be_empty }
      its(:constants) { should =~ Dugout::Math::Model.ops.map(&:name) }

      describe 'running #clean after compilation' do
        it 'deletes all the language constants' do
          reifier.clean!
          expression_language.constants.should be_empty
        end
      end
    end
  end
end
