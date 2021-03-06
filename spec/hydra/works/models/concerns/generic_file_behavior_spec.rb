require 'spec_helper'

describe Hydra::Works::GenericFileBehavior do
  class IncludesGenericFileBehavior < ActiveFedora::Base
    include Hydra::Works::GenericFileBehavior
  end
  subject { IncludesGenericFileBehavior.new }

  it 'ensures that objects will be recognized as generic_files' do
    expect(subject).to be_works_generic_file
  end
end
