class Tokens
  def self.integer?(s)
    s.to_s =~ /^[0-9]+$/
  end

  def self.symbol?(s)
    s.to_s =~ /^[0-9a-z\.\+\-\*\/][^\s]*$/
  end

  def self.string_open?(s)
    s.to_s == '."'
  end

  def self.string_close?(s)
    s.to_s == '"'
  end

  def self.defword_open?(s)
    s.to_s == ':'
  end

  def self.defword_close?(s)
    s.to_s == ';'
  end

  def self.command?(s)
    s.to_s =~ /^\](\w+)$/
  end
end
