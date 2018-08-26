require_relative 'formatted_time'

class App
  DATE_FORMATS = %w[year month day hour minute second]

  def call(env)
    @request = Rack::Request.new(env)
    build_response
  end

  private

  def proper_url?
    @request.path == '/time' && @request.query_string[0..6] == 'format='
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def build_response
    if proper_url? && unknown_formats.empty?
      [200, headers, time_response]
    elsif proper_url?
      [400, headers, unknown_format_response]
    else
      [404, headers, []]
    end
  end

  def unknown_format_response
    ["Unknown time format #{unknown_formats}\n"]
  end

  def time_response
    [FormattedTime.new(Time.now, formats).applay_template('-') + "\n"]
  end

  def formats
    @request.params['format'].gsub('minute', 'min').gsub('second', 'sec').split(",")
  end

  def original_formats
    @request.params['format'].split(",")
  end

  def unknown_formats
    original_formats - DATE_FORMATS
  end
end
