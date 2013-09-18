# encoding: utf-8
require 'spec_helper'

# integrates across the Compiled model and the parser
describe Dugout::Math::Model::OpCompiler do
  it_behaves_like 'an op compiler for a', Dugout::Math::Parser::DerivedOp do
    with_compiler_class Dugout::Math::Model::OpCompiler
  end

  it_behaves_like 'an op compiler for a', Dugout::Math::Parser::PrimitiveOp do
    with_compiler_class Dugout::Math::Model::OpCompiler
  end
end
