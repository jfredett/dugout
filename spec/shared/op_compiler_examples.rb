# encoding: utf-8
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
  let(:op_operator) { '@' }

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

    ast.operator op_operator

    Dugout::Math::Model::Reifier.clean!(test_namespace)
  end

  subject(:op_compiler) { compiler_class.new(ast, test_namespace) }

  context 'before running the compiler' do
    it 'has not yet defined the operator in the namespace' do
      test_namespace.constants.should_not include :Example
    end
  end

  context 'after running the compiler' do
    describe 'general case' do
      before { op_compiler.run! }

      it_behaves_like 'a generated class'
    end

    describe 'a unary op without a defined display function' do
      # we need to override these to known values
      let(:attributes) { [:only] }
      let(:only_val) { 1 }

      before { op_compiler.run! }

      it_behaves_like 'a generated class'

      subject(:op_instance) { test_namespace::Expression::Language::Example.new(only_val) }

      its(:to_s) { should == op_instance.inspect }
      its(:inspect) { should ==  "#{op_operator}(#{only_val})" }
    end

    describe 'binary ops' do
      describe 'without a defined display function' do
        context 'with a infix operator' do
          # we need to override these to known values
          let(:attributes) { [:left, :right] }
          let(:left_val) { 1 }
          let(:right_val) { 2 }
          let(:op_operator) { '@' }

          before { op_compiler.run! }

          it_behaves_like 'a generated class'

          subject(:op_instance) { test_namespace::Expression::Language::Example.new(left_val, right_val) }

          its(:to_s) { should == op_instance.inspect }
          its(:inspect) { should ==  "(#{left_val} #{op_operator} #{right_val})" }
        end

        context 'without an infix operator' do
          # we need to override these to known values
          let(:attributes) { [:left, :right] }
          let(:left_val) { 1 }
          let(:right_val) { 2 }
          let(:op_operator) { 'nth_root' }

          before { op_compiler.run! }

          it_behaves_like 'a generated class'

          subject(:op_instance) { test_namespace::Expression::Language::Example.new(left_val, right_val) }

          its(:to_s) { should == op_instance.inspect }
          its(:inspect) { should ==  "#{op_operator}(#{left_val},#{right_val})" }
        end
      end

      describe 'with a defined display function' do
        # we need to override these to known values
        let(:attributes) { [:left, :right] }
        let(:left_val) { 1 }
        let(:right_val) { 2 }

        before do
          ast.display_function { "Left: #{left}, Right: #{right}, Op: #{operator}" }
          op_compiler.run!
        end

        it_behaves_like 'a generated class'

        subject(:op_instance) { test_namespace::Expression::Language::Example.new(left_val, right_val) }

        its(:to_s) { should == op_instance.inspect }
        its(:inspect) { should ==  "Left: #{left_val}, Right: #{right_val}, Op: #{op_operator}" }
      end
    end
  end

  describe 'a n-ary op without a defined display function' do
    # we need to override these to known values
    let(:attributes) { [:left, :center, :right] }
    let(:left_val) { 1 }
    let(:right_val) { 2 }
    let(:center_val) { 3 }

    before { op_compiler.run! }

    it_behaves_like 'a generated class'

    subject(:op_instance) { test_namespace::Expression::Language::Example.new(left_val, center_val, right_val) }

    its(:to_s) { should == op_instance.inspect }
    its(:inspect) { should ==  "#{op_operator}(#{left_val},#{center_val},#{right_val})" }
  end

end

shared_examples_for 'a generated class' do
  it 'has defined the operator in the namespace' do
    test_namespace::Expression::Language.constants.should include :Example
  end

  describe 'the created class' do
    let(:example_op_class) { test_namespace::Expression::Language::Example }
    context 'class' do
      subject { example_op_class }

      specify { expect { example_op_class.new(*attributes) }.to_not raise_error }

      specify { expect { example_op_class.new(*attributes.drop(1)) }.to raise_error ArgumentError }

      specify { expect { example_op_class.new(*attributes.push(nil)) }.to raise_error ArgumentError }
    end

    context 'instance' do
      subject(:example_op) { example_op_class.new(*attributes) }

      it { should respond_to :operator }
      its(:operator) { should == op_operator }

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
