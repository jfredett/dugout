require 'spec_helper'

describe 'AST elements' do
  extend Dugout::Math # include the namespace

  specify "The following AST nodes exist" do
    defined?(Var).should be_true
    defined?(Literal).should be_true
    defined?(Multiply).should be_true
    defined?(Power).should be_true
    defined?(Exp).should be_true
    defined?(Add).should be_true
    defined?(Log).should be_true
  end

  describe Var do
    context 'class' do
      subject { Var }

      it { should be_unary }
      it { should_not be_binary }
      its(:arity) { should == 1 }
    end

    context 'instance' do
    end
  end

  describe Literal do
    context 'class' do
      subject { Literal }
      it { should be_unary }
      it { should_not be_binary }
      its(:arity) { should == 1 }
    end
    context 'instance' do
    end
  end

  describe Multiply do
    context 'class' do
      subject { Multiply }

      it { should_not be_unary }
      it { should be_binary }
      its(:arity) { should == 2 }
    end
    context 'instance' do
    end
  end

  describe Power do
    context 'class' do
      subject { Power }

      it { should_not be_unary }
      it { should be_binary }
      its(:arity) { should == 2 }
    end
    context 'instance' do
    end
  end

  describe Exp do
    context 'class' do
      subject { Exp }

      it { should be_unary }
      it { should_not be_binary }
      its(:arity) { should == 1 }
    end
    context 'instance' do
    end
  end

  describe Add do
    context 'class' do
      subject { Add }

      it { should_not be_unary }
      it { should be_binary }
      its(:arity) { should == 2 }
    end
    context 'instance' do
    end
  end

  describe Log do
    context 'class' do
      subject { Log }

      it { should be_unary }
      it { should_not be_binary }
      its(:arity) { should == 1 }
    end
    context 'instance' do
    end
  end
end
