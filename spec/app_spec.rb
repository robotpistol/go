describe 'go' do
  it 'allows accessing the home page' do
    get '/'
    # Rspec 2.x
    expect(last_response).to be_ok
  end
end
