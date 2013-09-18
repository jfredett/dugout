# encoding: utf-8
require 'spec_helper'

describe Dugout::Math::Model do
  subject { Dugout::Math::Model }

  describe Dugout::Math::Model::Defn do
    subject { Dugout::Math::Model::Defn }

    it { should be_a Dugout::Math::Parser::Model }
  end

  its(:primitive_ops) { should_not be_nil }
  its(:derived_ops) { should_not be_nil }
  its(:ops) { should_not be_nil }
end
