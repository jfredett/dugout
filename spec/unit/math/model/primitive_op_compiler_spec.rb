require 'spec_helper'

##
# These tests are all a bit gross, since we're operating on meta-meta program.
# This thing is testing the thing that will generate the code which will be used
# to do derivatives. It's a mad mad mad world.
#
describe Dugout::Math::Model::PrimitiveOpCompiler do
  let(:attributes) { [:left, :right] }

  let(:ast) {
    Dugout::Math::Model.model do
      primitive_op :Example do
      end
    end.children[Dugout::Math::Parser::PrimitiveOp].first
  }

  before do
    # after-the-fact setup makes it easier to decouple what attrs I'm defining
    attributes.each do |attr|
      ast.attribute attr
    end

    ast.operator '@'
  end

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

