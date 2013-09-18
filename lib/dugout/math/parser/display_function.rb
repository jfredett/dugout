# encoding: utf-8
module Dugout
  module Math
    module Parser
      class DisplayFunction
        include Katuv::Node
        terminal!

        def self.name
          'display_function'
        end
      end
    end
  end
end

