# encoding: utf-8
require 'spec_helper'

describe Dugout::Math::Model::Simplifier do
  let(:expression_namespace) { Dugout::Math::Model::Expression }
  let(:simplifier) { Dugout::Math::Model::Simplifier }

  def self.assert_identity(opts = {})
    let(:expression) { expression_namespace.define &opts[:expression] }
    let(:expectation) { expectation_namespace.define &opts[:expression] }
    let(:simplified_expression) { simplifier.simplify(expression) }

    specify { simplified_expression.should == expectation }
  end

  assert_identity(
    expression:  proc { exp(log(x)) },
    expectation: proc { x }
  )

  pending do
    assert_identity(
      expression:  proc { log(exp(x)) },
      expectation: proc { x }
    )

    assert_identity(
      expression: proc { x - x },
      expectation: proc { lit(0) }
    )

    assert_identity(
      expression: proc { x / x },
      expectation: proc { lit(1) }
    )

    assert_identity(
      expression: proc { D(lit(0), x) },
      expectation: proc { lit(0) }
    )

    assert_identity(
      expression: proc { D(x, x) },
      expectation: proc { lit(1) }
    )

    assert_identity(
      expression: proc { D(10, x) },
      expectation: proc { lit(0) }
    )

    assert_identity(
      expression: proc { D(exp(x), x) },
      expectation: proc { exp(x) }
    )

    assert_identity(
      expression: proc { D(lit(1) / x, x) },
      expectation: proc { lit(-1) / x ** lit(2) }
    )

    assert_identity(
      expression: proc { D(x ** k, x) },
      expectation: proc { k * x ** (k - lit(1)) }
    )

    assert_identity(
      expression: proc { D(log(x), x) },
      expectation: proc { lit(1) / x }
    )

    assert_identity(
      expression: proc { D(x + y, x) },
      expectation: proc { lit(1) }
    )

    assert_identity(
      expression: proc { D(x*y, x) },
      expectation: proc { y }
    )

    assert_identity(
      expression: proc { D(x*log(x), x) },
      expectation: proc { log(x) + lit(1) }
    )

    assert_identity(
      expression: proc { D(x*log(y + x), x) },
      expectation: proc { log(y + x) + x / (y + x) }
    )

    assert_identity(
      expression: proc { D(D(x, x), x) },
      expectation: proc { 0 }
    )

    assert_identity(
      expression: proc { D(D(x ** k, x), x) },
      expectation: proc { k * (k - lit(1)) * x ** (k - lit(2)) }
    )

    assert_identity(
      expression: proc { D(D(exp(x), x), x) },
      expectation: proc { exp(x) }
    )
  end


  #context 'when variables are not used' do
  #describe 'simplifying a simple expression' do
  #subject(:expression) { expression_namespace.define {} }
  #end

  #describe 'simplifying a really complicated expression' do

  #end
  #end

  #context 'when variables are involved' do
  #describe 'simplifying a simple expression' do

  #end

  #describe 'simplifying a complicated expression' do

  #end

  #describe 'simplifying a simple, first order derivative' do
  #subject(:expression) { expression_namespace.define { D(lit(2) * x + lit(10), x)) } }
  #let(:expectation) { expression_namespace.define { lit(2) } }
  #end

  #describe 'simplifying a simple second order derivative' do

  #end

  #describe 'simplifying a complicated, first order derivative' do
  #subject(:expression) { expression_namespace.define { D(log(lit(10) * var(:x) - lit(3) * log(var(:x)) + exp(var(:y))), var(:x)) } }

  #end

  #describe 'simplifying a complicated, second order derivative' do

  #end
  #end
end
