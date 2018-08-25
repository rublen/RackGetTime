class App
  DATE_FORMATS = %w[year month day hour minute second]

  def call(env)
    @env = env
    [status, headers, body]
  end

  private

  def status
    if @env['PATH_INFO'] == '/time' && @env['QUERY_STRING'][0..6] == 'format='
      unknown_formats.empty? ? 200 : 400
    else
      404
    end
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    return [] if status == 404
    return ["Unknown time format #{unknown_formats}\n"] if status == 400
    [
      formats.map do |f|
        time_item = Time.now.public_send(f)
        f == 'year' ? time_item : "%02d" % [time_item]
      end.join('-') + "\n"
    ]
  end

  def formats
    @env['QUERY_STRING'].gsub('minute', 'min').gsub('second', 'sec').split("=")[1].split("%2C")
  end

  def original_formats
    @env['QUERY_STRING'].split("=")[1].split("%2C")
  end

  def unknown_formats
    original_formats - DATE_FORMATS
  end
end
