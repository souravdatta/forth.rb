require './defaults.rb'
require './scanner.rb'
require './tokens.rb'
require './data.rb'
require './fn.rb'
require './commands.rb'


class Interpreter
  def initialize(stack: nil, dict: nil, outer_layer: false)
    @scanner = nil
    @stack = stack || Stack.new
    @dict = dict || Dictionary.new
    @dict.build_default_dictionary unless dict
    @outer_layer = outer_layer
    @command_runner = CommandRunner.new(@stack, @dict)
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

  def interpret_command
    cmd = []
    while @scanner.has_more?
      cmd << @scanner.next
    end
    @command_runner.run cmd
  end

  def interpret_if
    cmd = []
    if_part = []
    else_part = []
    while @scanner.has_more? do
      w = @scanner.next
      if not Tokens.if_close?(w)
        cmd << w
      else
        break
      end
    end

    fill_target = if_part
    for x in cmd
      if x == 'else'
        fill_target = else_part
        next
      end
      fill_target << x
    end

    cond = @stack.pop

    if (cond == true) || (cond == 1)
      UserDefined.new('__if_block', if_part.join(' '), @dict).exec(@stack)
    else
      UserDefined.new('__if_block', else_part.join(' '), @dict).exec(@stack)
    end
  end

  def interpret_token(token)
    if Tokens.integer? token
      @stack.push token
    elsif Tokens.string_open? token
      self.interpret_string
    elsif Tokens.defword_open? token
      self.interpret_defword
    elsif Tokens.command? token
      @scanner.put_back token
      self.interpret_command
    elsif Tokens.if_open? token
      self.interpret_if
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



