class Dictionary
  def initialize
    @table = Hash.new
  end

  def add_word(fn)
    @table[fn.symbol] = fn
  end

  def find_word(word)
    @table[word]
  end

  def build_default_dictionary
    DEFAULTS.each {|fn| self.add_word fn}
  end
end

class Stack
  def initialize
    @stk = []
  end

  def push(x)
    @stk.unshift x
  end

  def pop
    if @stk.length == 0
      raise 'empty stack'
    end
    @stk.shift
  end

  def swap
    if @stk.length >= 2
      @stk[-2], @stk[-1] = @stk[-1], @stk[2]
    end
  end

  def to_s
    '| ' + @stk.reverse.join(' | ') + ' >'
  end

  def length
    @stk.length
  end
end