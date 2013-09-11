require 'spec_helper'

describe Dugout::Math::Model::DerivedOpCompiler do
  it_behaves_like 'an op compiler for a', Dugout::Math::Parser::DerivedOp do
    with_compiler_class Dugout::Math::Model::DerivedOpCompiler
  end
end
