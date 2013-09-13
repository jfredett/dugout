require 'spec_helper'

describe Dugout::Math::Model::Reifier do
  subject(:reifier) { Dugout::Math::Model::Reifier }

  describe 'api' do
    it { should respond_to :compile! }
    it { should respond_to :clean! }
  end
end
