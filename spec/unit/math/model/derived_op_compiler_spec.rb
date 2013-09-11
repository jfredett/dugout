require 'spec_helper'

describe Dugout::Math::Model::DerivedOpCompiler do
  let(:attributes) { [:left, :center, :right] }

  let(:ast) {
    Dugout::Math::Model.model do
      derived_op :Example do
      end
    end.children[Dugout::Math::Parser::DerivedOp].first
  }

  before do
    # after-the-fact setup makes it easier to decouple what attrs I'm defining
    attributes.each do |attr|
      ast.attribute attr
    end

    ast.operator '@'

    ast.implementation do
      Example.new(left, right, 0)
    end
  end

  subject(:derivedop) { Dugout::Math::Model::DerivedOpCompiler.new(ast, Dugout::Math::Model) }

  after { Dugout::Math::Model.send(:remove_const, :Example) rescue nil }

  context 'before running the compiler' do
    it "has not yet defined the operator in the namespace" do
      defined?(Dugout::Math::Model::Example).should_not be
    end
  end

  context 'after running the compiler' do
    before { derivedop.run! }

    it "has defines the operator in the namespace" do
      defined?(Dugout::Math::Model::Example).should be
    end

    describe 'the created class' do
      let(:left) { double('left') }
      let(:right) { double('right') }
      let(:center) { double('center') }

      context 'class' do
        subject(:example_op_class) { Dugout::Math::Model::Example }

        specify { expect { example_op_class.new(*attributes) }.to_not raise_error }

        specify { expect { example_op_class.new(*attributes.drop(1) ) }.to raise_error ArgumentError }

        specify { expect { example_op_class.new(*attributes.push(nil)) }.to raise_error ArgumentError }
      end

      context 'instance' do
        subject(:example_op) { Dugout::Math::Model::Example.new(left, center, right) }

        it 'defines a method for each attribute' do
          attributes.each do |attr|
            example_op.should respond_to attr
          end
        end

        it 'assigns the attributes correctly in the initializer' do
          attributes.each do |attr|
            example_op.send(attr).should == send(attr)
          end
        end
      end
    end
  end
end
