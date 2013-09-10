require 'spec_helper'

describe Dugout::Math::Model::DerivedOpCreator do
  let(:ast) {
    Dugout::Math::Model.model do
      derived_op :Example do
        attribute :left
        attribute :right

        operator '@'

        implementation do
          Example.new(left, right, 0)
        end
      end
    end.children[Dugout::Math::Parser::DerivedOp].first
  }
  subject(:derivedop) { Dugout::Math::Model::DerivedOpCreator.new(ast, Dugout::Math::Model) }

  after { Dugout::Math::Model.send(:remove_const, :Example) rescue nil }

  context 'before running the creator' do
    it "has not yet defined the operator in the namespace" do
      defined?(Dugout::Math::Model::Example).should_not be
    end
  end

  context 'after running the creator' do
    before { derivedop.run! }

    it "has defines the operator in the namespace" do
      defined?(Dugout::Math::Model::Example).should be
    end
  end
end
