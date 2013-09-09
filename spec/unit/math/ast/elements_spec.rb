require 'spec_helper'

describe ' elements' do
  specify "The following  nodes exist" do
    defined?(Dugout::Math::Var).should be_true
    defined?(Dugout::Math::Literal).should be_true
    defined?(Dugout::Math::Multiply).should be_true
    defined?(Dugout::Math::Power).should be_true
    defined?(Dugout::Math::Exp).should be_true
    defined?(Dugout::Math::Add).should be_true
    defined?(Dugout::Math::Log).should be_true
  end

  describe Dugout::Math::Var do
    context 'class' do
      subject { Dugout::Math::Var }

      it { should be_unary }
      it { should_not be_binary }
      its(:arity) { should == 1 }
    end

    context 'instance' do
    end
  end

  describe Dugout::Math::Literal do
    context 'class' do
      subject { Dugout::Math::Literal }
      it { should be_unary }
      it { should_not be_binary }
      its(:arity) { should == 1 }
    end
    context 'instance' do
    end
  end

  describe Dugout::Math::Multiply do
    context 'class' do
      subject { Dugout::Math::Multiply }

      it { should_not be_unary }
      it { should be_binary }
      its(:arity) { should == 2 }
    end
    context 'instance' do
    end
  end

  describe Dugout::Math::Power do
    context 'class' do
      subject { Dugout::Math::Power }

      it { should_not be_unary }
      it { should be_binary }
      its(:arity) { should == 2 }
    end
    context 'instance' do
    end
  end

  describe Dugout::Math::Exp do
    context 'class' do
      subject { Dugout::Math::Exp }

      it { should be_unary }
      it { should_not be_binary }
      its(:arity) { should == 1 }
    end
    context 'instance' do
    end
  end

  describe Dugout::Math::Add do
    context 'class' do
      subject { Dugout::Math::Add }

      it { should_not be_unary }
      it { should be_binary }
      its(:arity) { should == 2 }
    end
    context 'instance' do
    end
  end

  describe Dugout::Math::Log do
    context 'class' do
      subject { Dugout::Math::Log }

      it { should be_unary }
      it { should_not be_binary }
      its(:arity) { should == 1 }
    end
    context 'instance' do
    end
  end
end
