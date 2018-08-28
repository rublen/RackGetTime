require_relative 'time_formatter'

class App
  def call(env)
    @request = Rack::Request.new(env)
    @formatter = TimeFormatter.new(@request.params['format'])
    build_response
  end

  private
  attr_reader :request, :formatter

  def build_response
    case request.path
    when '/time'
      time_response
    else
      not_found_response
    end
  end

  def time_response
    if formatter.valid_format?
      [200, headers, format_body]
    else
      [400, headers, unknown_format_body]
    end
  end

  def not_found_response
    [404, headers, []]
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def format_body
    [formatter.result('-') + "\n"]
  end

  def unknown_format_body
    ["Unknown time format #{formatter.unknown_formats}\n"]
  end
end
