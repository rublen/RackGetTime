class FormattedTime
  def initialize(time, time_items)
    @time = time
    @time_items = time_items
  end

  def applay_template(separator)
    @time_items.map do |item|
      item == 'year' ? @time.public_send(item) : "%02d" % [@time.public_send(item)]
    end.join(separator)
  end
end
