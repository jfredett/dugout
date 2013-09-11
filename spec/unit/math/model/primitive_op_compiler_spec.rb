require 'spec_helper'

describe Dugout::Math::Model::PrimitiveOpCompiler do
  let(:ast) {
    Dugout::Math::Model.model do
      primitive_op :Example do
        attribute :left
        attribute :right

        operator '@'
      end
    end.children[Dugout::Math::Parser::PrimitiveOp].first
  }
  subject(:primop) { Dugout::Math::Model::PrimitiveOpCompiler.new(ast, Dugout::Math::Model) }

  after { Dugout::Math::Model.send(:remove_const, :Example) rescue nil }

  context 'before running the compiler' do
    it "has not yet defined the operator in the namespace" do
      defined?(Dugout::Math::Model::Example).should_not be
    end
  end

  context 'after running the compiler' do
    before { primop.run! }

    it "has defines the operator in the namespace" do
      defined?(Dugout::Math::Model::Example).should be
    end

    describe 'the created class' do
      let(:left) { double('left') }
      let(:right) { double('right') }

      context 'class' do
        subject(:example_op_class) { Dugout::Math::Model::Example }

        specify { expect { example_op_class.new(left, right) }.to_not raise_error }

        specify { expect { example_op_class.new(left) }.to raise_error ArgumentError }

        specify { expect { example_op_class.new(left, right, nil) }.to raise_error ArgumentError }
      end

      context 'instance' do
        subject(:example_op) { Dugout::Math::Model::Example.new(left, right) }

      end
    end
  end
end

