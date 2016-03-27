require_relative '../../../lib/pup/request'

describe Pup::Request do
  subject {
    described_class.new(:get, '/foo?bar=baz', request_headers, nil)
  }

  let(:request_headers) {
    {
      'Accept' => 'application/json',
      'Cache-Control' => 'no-cache',
      'X-Requested-With' => 'XMLHttpRequest'
    }
  }

  describe '#to_env' do
    let(:env) { subject.to_env }

    it 'includes REQUEST_METHOD' do
      expect(env['REQUEST_METHOD']).to eql('get')
    end

    it 'includes PATH_INFO' do
      expect(env['PATH_INFO']).to eql('/foo')
    end

    it 'includes QUERY_STRING' do
      expect(env['QUERY_STRING']).to eql('bar=baz')
    end

    it 'includes HTTP request headers' do
      expect(env['HTTP_ACCEPT']).to eql('application/json')
      expect(env['HTTP_CACHE_CONTROL']).to eql('no-cache')
      expect(env['HTTP_X_REQUESTED_WITH']).to eql('XMLHttpRequest')
    end
  end
end
