require 'spec_helper'

describe Dugout::Math::Model::PrimitiveOpCompiler do
  it_behaves_like 'an op compiler for a', Dugout::Math::Parser::PrimitiveOp do
    with_compiler_class Dugout::Math::Model::PrimitiveOpCompiler 
  end
end

