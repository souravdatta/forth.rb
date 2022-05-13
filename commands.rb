class CommandRunner
  def initialize(stack, dict)
    @stack = stack
    @dict = dict
  end

  def run(cmds)
    if cmds.length >= 1
      message = cmds[0][1..-1]
      args = cmds[1..-1]
      self.send message, *args
    end
  end

  def stack
    puts @stack
  end
end