require 'spec_helper'

describe GG do
  describe :config do
    it 'should accept and persist all setters on a virgin Config' do
      GG.config.elmar = 'fudd'
      GG.config.elmar.should == 'fudd'
    end
  end
end