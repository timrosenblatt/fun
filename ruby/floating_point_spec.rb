describe 'Floating point math' do
  # http://stackoverflow.com/questions/4055618/ruby-floating-point-errors
  # http://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html

  it 'is weird' do
    val = 129.95 * 10

    expect(val < 12995).to be true
    expect(val == 12995).to be false
  end

  it 'is not always transitive' do
    val = 129.95 * 10 * 10

    expect(val).to eq 12995
  end

  it 'does not work well' do
    val = 0.1 + 0.2

    expect(val).to_not eq 0.3
    expect(val > 0.3).to be true
  end

  it 'is not as good as BigDecimal' do
    require 'bigdecimal'

    val = BigDecimal('0.1') + BigDecimal('0.2')

    expect(val).to eq 0.3
  end
end
