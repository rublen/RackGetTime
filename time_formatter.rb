class TimeFormatter
  DATE_FORMATS = %w[year month day hour minute second]

  def initialize(format_string, time = Time.now)
    @format_string = format_string || ''
    @time = time
  end

  def result(separator)
    formats.map do |item|
      item == 'year' ? time.public_send(item) : "%02d" % [time.public_send(item)]
    end.join(separator)
  end

  def valid_format?
    unknown_formats.empty?
  end

  def unknown_formats
    original_formats - DATE_FORMATS
  end

  private
  attr_reader :format_string, :time

  def formats
    format_string.gsub('minute', 'min').gsub('second', 'sec').split(",")
  end

  def original_formats
    format_string.split(",")
  end
end
