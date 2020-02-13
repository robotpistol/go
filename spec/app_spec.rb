describe 'airgo', :type => :request do
  describe 'GET /' do
    subject { get '/', {}, headers }

    let(:headers) { {} }
    let(:params) { {} }

    context 'with default json' do
      it 'allows accessing the home page' do
        subject
        expect(last_response).to be_ok
      end

      it 'returns html response' do
        subject
        expect(last_response.content_type).to start_with('text/html')
      end
    end

    context 'with accept json' do
      let(:headers) { super().merge('HTTP_ACCEPT' => 'application/json') }

      it 'returns json response' do
        subject
        expect(last_response.content_type).to start_with('application/json')
      end

      it 'returns empty list' do
        subject
        expect(last_response.body).to eq([].to_json)
      end
    end
  end
end
