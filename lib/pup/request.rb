module Pup
  class Request
    def initialize(method, path, headers, body)
      @method = method
      @path = path
      @headers = headers
      @body = body
    end

    attr_reader :method, :path, :headers, :body
  end
end
