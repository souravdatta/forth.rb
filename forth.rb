require './defaults.rb'


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

class Tokens
  def self.integer?(s)
    s.to_s =~ /[0-9]+/
  end

  def self.symbol?(s)
    s.to_s =~ /[a-z\.\+\-\*\/][^\s]*/
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
end

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
    @stk.reverse.join(' ')
  end
end

class Fn
  def exec(stk)
    raise 'Abstract method, please override in a child class'
  end

  def symbol
    raise 'Abstract method, please override in a child class'
  end
end

class Builtin < Fn
  attr_accessor :symbol

  def initialize(sym, &block)
    @symbol = sym
    @proc = block
  end

  def exec(stk)
    @proc.call(stk)
  end
end

class UserDefined < Fn
  attr_accessor :symbol

  def initialize(sym, body, dict)
    @symbol = sym
    @body = body
    @dict = dict
  end

  def exec(stk)
    interpreter = Interpreter.new(stack: stk, dict: @dict)
    interpreter.interpret(@body)
  end
end

class Interpreter
  def initialize(stack: nil, dict: nil, outer_layer: false)
    @scanner = nil
    @stack = stack || Stack.new
    @dict = dict || Dictionary.new
    @dict.build_default_dictionary unless dict
    @outer_layer = outer_layer
  end

  def parse(line)
    @scanner = Scanner.new(line)
  end

  def interpret(line)
    self.parse line

    while @scanner.has_more? do
      token = @scanner.next
      self.interpret_token token
    end

    if @outer_layer
      puts ' ok'
    end
  end

  def interpret_string
    str = []
    while @scanner.has_more? do
      w = @scanner.next
      if not Tokens.string_close?(w)
        str << w
      else
        break
      end
    end
    print str.join(' '), ' '
  end

  def interpret_defword
    str = []
    symname = nil

    if @scanner.has_more?
      w = @scanner.next
      if Tokens.symbol?(w)
        symname = w
      else
        raise 'def word found a non symbol name for word'
      end
    else
      raise 'def word is incomplete'
    end

    while @scanner.has_more? do
      w = @scanner.next
      if not Tokens.defword_close?(w)
        str << w
      else
        break
      end
    end

    fn = UserDefined.new(symname, str.join(' '), @dict)
    @dict.add_word(fn)
  end

  def interpret_token(token)
    if Tokens.integer? token
      @stack.push token
    elsif Tokens.string_open? token
      self.interpret_string
    elsif Tokens.defword_open? token
      self.interpret_defword
    elsif Tokens.symbol? token
      action = @dict.find_word(token)
      if action.nil?
        p "-- do not know what to do with #{token}"
      else
        action.exec(@stack)
      end
    else
      p "-- do not know what #{token} means!!"
    end
  end

  def to_s
    @stack.to_s
  end

  def self.repl
    forth = Interpreter.new(outer_layer: true)
    while true do
      print '?  '
      line = readline
      begin
        forth.interpret line
      rescue => err
        puts 'Not ok'
        puts err
      end
    end
  end
end



