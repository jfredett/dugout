require 'spec_helper'

describe Dugout::Math::Parser do
  specify 'The following DSL classes are defined' do
    defined?(Dugout::Math::Parser::Attribute).should be
    defined?(Dugout::Math::Parser::DisplayFunction).should be
    defined?(Dugout::Math::Parser::Implementation).should be
    defined?(Dugout::Math::Parser::Op).should be
    defined?(Dugout::Math::Parser::PrimitiveOp).should be
    defined?(Dugout::Math::Parser::DerivedOp).should be
    defined?(Dugout::Math::Parser::Model).should be
  end

  describe Dugout::Math::Parser::Attribute do
    subject { Dugout::Math::Parser::Attribute }

    its(:ancestors) { should include Katuv::Node }
    it { should be_terminal }
  end

  describe Dugout::Math::Parser::DisplayFunction do
    subject { Dugout::Math::Parser::DisplayFunction }

    its(:ancestors) { should include Katuv::Node }
    its(:name) { should == 'display_function' }
    it { should be_terminal }
  end

  describe Dugout::Math::Parser::Implementation do
    subject { Dugout::Math::Parser::Implementation }

    its(:ancestors) { should include Katuv::Node }
    it { should be_terminal }
  end

  describe Dugout::Math::Parser::Op do
    subject { Dugout::Math::Parser::Op }

    its(:ancestors) { should include Katuv::Node }
    it { should_not be_terminal }
  end

  describe Dugout::Math::Parser::PrimitiveOp do
    subject { Dugout::Math::Parser::PrimitiveOp }

    its(:ancestors) { should include Katuv::Node }
    its(:name) { should == 'primitive_op' }
    it { should_not be_terminal }
  end

  describe Dugout::Math::Parser::DerivedOp do
    subject { Dugout::Math::Parser::DerivedOp }

    its(:ancestors) { should include Katuv::Node }
    its(:name) { should == 'derived_op' }
    it { should_not be_terminal }
  end

  describe Dugout::Math::Parser::Model do
    subject { Dugout::Math::Parser::Model }

    its(:ancestors) { should include Katuv::Node }
    it { should_not be_terminal }
  end
end
