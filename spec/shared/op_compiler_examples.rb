require 'spec_helper'

##
# These tests are all a bit gross, since we're operating on meta-meta program.
# This thing is testing the thing that will generate the code which will be used
# to do derivatives. It's a mad mad mad world.
#
shared_examples_for 'an op compiler for a' do |op_class|
  def self.with_compiler_class(klass)
    let(:compiler_class) { klass }
  end

  let(:attributes) { ('a'..'z').to_a.sample(rand(10) + 1) }

  # These dynamically construct the AST node we need to test against
  let(:dsl_namespace) { Dugout::Math::Model.model }
  let(:ast) { dsl_namespace.send(op_class.name, :Example).first }
  # This is where we'll put the compiled constants, we have to ensure it
  # exists first.
  let(:test_namespace) { module Test; end ; Test }
  # Clean up the namespace after each test
  after { Object.send(:remove_const, test_namespace.to_s.to_sym) }

  # Build the AST incrementally -- it's easier to decouple the specific attrs
  # this way
  before do
    attributes.each do |attr|
      ast.attribute attr
    end

    ast.operator '@'
  end

  subject(:op_compiler) { compiler_class.new(ast, test_namespace) }

  context 'before running the compiler' do
    it "has not yet defined the operator in the namespace" do
      defined?(test_namespace::Example).should_not be
    end
  end

  context 'after running the compiler' do
    before { op_compiler.run! }

    it "has defines the operator in the namespace" do
      defined?(test_namespace::Example).should be
    end

    describe 'the created class' do
      context 'class' do
        subject(:example_op_class) { test_namespace::Example }

        specify { expect { example_op_class.new(*attributes) }.to_not raise_error }

        specify { expect { example_op_class.new(*attributes.drop(1) ) }.to raise_error ArgumentError }

        specify { expect { example_op_class.new(*attributes.push(nil)) }.to raise_error ArgumentError }
      end

      context 'instance' do
        subject(:example_op) { test_namespace::Example.new(*attributes) }

        it 'defines a method for each attribute' do
          attributes.each do |attr|
            example_op.should respond_to attr
          end
        end

        it 'assigns the attributes correctly in the initializer' do
          attributes.each do |attr|
            example_op.send(attr).should == attr
          end
        end
      end
    end
  end
end
