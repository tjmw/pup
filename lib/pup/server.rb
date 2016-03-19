module Pup
  class Server
    RACK_APP = ->(env) {
      ['200', {'Content-Type' => 'text/html'}, ['This is a rack app yo!']]
    }

    def initialize(port)
      @port = port
      @app = RACK_APP
      listen
    end

    private

    attr_reader :port, :app

    def listen
      log "Pup::Server listening on port #{port}"

      Socket.tcp_server_loop(port) do |connection|
        request = parse_http_request(connection)

        env = build_env_from_request(request)

        status, headers, body = app.call(env)

        log "method=#{request.method} path=#{request.path} status=#{status}"

        response = build_response(status, headers, body)

        connection.write(response)

        connection.close
      end
    end

    def parse_http_request(connection)
      Parser.new(connection).read_http_request
    end

    def build_env_from_request(request)
      return {}
    end

    def build_response(status, headers, body)
      formatted_headers = headers.map {|k,v| "#{k}: #{v}" }.join("\r\n")

      <<-RESPONSE.strip_heredoc
        HTTP/1.1 #{status} #{Rack::Utils::HTTP_STATUS_CODES[status.to_i]}
        #{formatted_headers}
        Content-Length: #{body.join('').bytesize}

        #{body.join('')}
      RESPONSE
    end

    def log(message)
      puts "#{Time.now} | #{message}"
    end
  end
end
