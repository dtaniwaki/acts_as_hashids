require 'spec_helper'

describe ActsAsHashids do
  it 'has a version number' do
    expect(ActsAsHashids::VERSION).not_to be nil
  end
  it 'defines acts_as_hashids method in ActiveRecord::Base' do
    expect(ActiveRecord::Base).to respond_to(:acts_as_hashids)
  end
end
