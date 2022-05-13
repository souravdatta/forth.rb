class Fn
  def exec(stk)
    raise 'Abstract method, please override in a child class'
  end

  def symbol
    raise 'Abstract method, please override in a child class'
  end

  def definition
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

  def definition
    "Builtin method #{self.symbol}"
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

  def definition
    "#@body"
  end
end