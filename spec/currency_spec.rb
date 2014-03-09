require 'spec_helper'

describe Currency do
  it { should belong_to(:trader) }
end
