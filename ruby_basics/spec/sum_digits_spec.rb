RSpec.describe 'sum_digits', :sum_digits do
  it 'sums digits for digit 0' do
    expect(sum_digits(0)).to eq(0)
  end

  it 'sums digits for digit 1' do
    expect(sum_digits(1)).to eq(1)
  end

  it 'sums digits for digit 2' do
    expect(sum_digits(2)).to eq(2)
  end

  it 'sums digits for digit 3' do
    expect(sum_digits(3)).to eq(3)
  end

  it 'sums digits for digit 4' do
    expect(sum_digits(4)).to eq(4)
  end

  it 'sums digits for digit 5' do
    expect(sum_digits(5)).to eq(5)
  end

  it 'sums digits for digit 6' do
    expect(sum_digits(6)).to eq(6)
  end

  it 'sums digits for digit 7' do
    expect(sum_digits(7)).to eq(7)
  end

  it 'sums digits for digit 8' do
    expect(sum_digits(8)).to eq(8)
  end

  it 'sums digits for digit 9' do
    expect(sum_digits(9)).to eq(9)
  end

  it 'sums digits for number 11' do
    expect(sum_digits(11)).to eq(2)
  end

  it 'sums digits for number 97' do
    expect(sum_digits(97)).to eq(7)
  end

  it 'sums digits for number 642' do
    expect(sum_digits(642)).to eq(3)
  end

  it 'sums digits for number 58_492' do
    expect(sum_digits(58_492)).to eq(1)
  end
end
