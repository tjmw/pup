module Pup
  class Parser
    BYTES_TO_READ = 1024 * 16

    def initialize(connection)
      @connection = connection
      @parser = build_parser
      @done = false
      @headers = []
    end

    def read_http_request
      request = HttpParser::Parser.new_instance do |inst|
        inst.type = :request
      end

      begin
        while data = connection.readpartial(BYTES_TO_READ) do
          parser.parse(request, data)
          raise EOFError if done
        end
      rescue EOFError
      end

      Request.new(request.http_method, path, Hash[*headers], body)
    end

    private

    attr_reader :connection, :parser, :done, :path, :headers, :body

    def build_parser
      HttpParser::Parser.new do |p|
        p.on_message_complete do |_|
          @done = true
        end

        p.on_url do |_, path|
          @path = path
        end

        p.on_header_field do |_, header_name|
          headers << header_name
        end

        p.on_header_value do |_, header_value|
          headers << header_value
        end
      end
    end
  end
end
