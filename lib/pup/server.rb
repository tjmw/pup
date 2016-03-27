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

        env = request.to_env

        status, headers, body = app.call(env)

        connection.write "HTTP/1.1 #{status} #{Rack::Utils::HTTP_STATUS_CODES[status.to_i]}\r\n"

        headers.each do |k,v|
          connection.write "#{k}: #{v}\r\n"
        end

        unless headers.has_key?('Content-Length')
          connection.write "Content-Length: #{body.join('').bytesize}\r\n"
        end

        if body.length > 0
          connection.write "\r\n"

          body.each do |b|
            connection.write b
          end

          connection.write "\r\n"
        end

        connection.close

        log "method=#{request.method} path=#{request.path} status=#{status}"
      end
    end

    def parse_http_request(connection)
      Parser.new(connection).read_http_request
    end

    def log(message)
      puts "#{Time.now} | #{message}"
    end
  end
end
