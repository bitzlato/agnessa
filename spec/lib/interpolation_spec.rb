require 'rails_helper'

RSpec.describe Interpolation do

  it 'success interpolate' do
    str = described_class.interpolate '%{foo} %{bar}', {foo: 'bar', bar: 'foo'}
    expect(str).to eq('bar foo')
  end
end
