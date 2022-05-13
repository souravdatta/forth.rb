class Scanner
  def initialize(line)
    @line = line.chomp
    @parts = @line.split(/\s+/)
    @index = 0
  end

  def next
    if @index >= @parts.length
      return :eof
    end

    next_thing = @parts[@index]
    @index += 1
    next_thing
  end

  def has_more?
    @index < @parts.length
  end

  def words
    @parts.clone
  end

  def put_back(w)
    @parts.unshift w
  end
end
