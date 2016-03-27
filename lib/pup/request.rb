module Pup
  class Request
    def initialize(method, path, headers, body)
      @method = method
      @path = path
      @headers = headers
      @body = body
    end

    attr_reader :method, :path, :headers, :body

    # See http://www.rubydoc.info/github/rack/rack/master/file/SPEC
    def to_env
      @to_env ||= begin
        env = {}
        env['REQUEST_METHOD'] = method.to_s
        env['PATH_INFO'] = path.split('?')[0]
        env['QUERY_STRING'] = path.split('?')[1]

        env = headers.each_with_object(env) {|(k,v),memo|
          env_key = "HTTP_#{k.gsub('-','_').upcase}"
          memo[env_key] = v
        }

        env
      end
    end
  end
end
