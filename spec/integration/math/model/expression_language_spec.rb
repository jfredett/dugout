# encoding: utf-8
require 'spec_helper'

describe Dugout::Math::Model::Expression::Language do
  subject(:reifier) { Dugout::Math::Model::Reifier }
  let(:expression_evaluator) { Dugout::Math::Model::Expression::Evaluator }
  let(:expression_language) { Dugout::Math::Model::Expression::Language }

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
      specify { expression_evaluator.constants.should include :InfixOperators }

      describe 'running #clean after compilation' do
        it 'deletes all the language constants' do
          reifier.clean!
          expression_language.constants.should be_empty
        end
      end

      describe 'ast equality' do
        let(:e) { expression_language } # for convenience below
        let(:ast) do
          e::Log.new(
            e::Addition.new(
              e::Variable.new(:x),
              e::Literal.new(10)
            )
          )
        end
        let(:equal_ast) do
          e::Log.new(
            e::Addition.new(
              e::Variable.new(:x),
              e::Literal.new(10)
            )
          )
        end
        let(:equivalent_nonequal_ast) do
          e::Log.new(
            e::Addition.new(
              e::Literal.new(10),
              e::Variable.new(:x)
            )
          )
        end
        let(:completely_different_ast) do
          e::Exponential.new(
            e::Subtraction.new(
              e::Variable.new(:i),
              e::Literal.new(1129310)
            )
          )
        end

        specify { ast.should == ast }
        specify { ast.should == equal_ast }
        specify { ast.should_not == equivalent_nonequal_ast }
        specify { ast.should_not == completely_different_ast }

      end
    end
  end
end
