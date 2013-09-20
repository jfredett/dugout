# encoding: utf-8
require 'spec_helper'

describe Dugout::Math::Model::Simplifier do
  let(:expression_namespace) { Dugout::Math::Model::Expression }

  context 'identities' do
    # exp(log(x)) == x
    # log(exp(x)) == x
    # x - x == 0
    # x / x == 1
    # D(0) == 0
    # D(x) == 1
    # D(x^k) = kx^k-1
    # D(log(x)) = 1/x
    # ... etc
  end

  context 'when variables are not used' do
    describe 'simplifying a simple expression' do
      subject(:expression) { expression_namespace.define {} }
    end

    describe 'simplifying a really complicated expression' do

    end
  end

  context 'when variables are involved' do
    describe 'simplifying a simple expression' do

    end

    describe 'simplifying a complicated expression' do

    end

    describe 'simplifying a simple, first order derivative' do
      subject(:expression) { expression_namespace.define { D(lit(2) * x + lit(10), x)) } }
      let(:expectation) { expression_namespace.define { lit(2) } }
    end

    describe 'simplifying a simple second order derivative' do

    end

    describe 'simplifying a complicated, first order derivative' do
      subject(:expression) { expression_namespace.define { D(log(lit(10) * var(:x) - lit(3) * log(var(:x)) + exp(var(:y))), var(:x)) } }

    end

    describe 'simplifying a complicated, second order derivative' do

    end
  end
end
