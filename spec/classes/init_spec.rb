require 'spec_helper'
describe 'hazelcast' do

  context 'with defaults for all parameters' do
    it { should contain_class('hazelcast') }
  end
end
