require './forth.rb'

DEFAULTS = [
    Builtin.new('+') do |stk|
      # (n1 n2 -- n1+n2)
      n2 = stk.pop
      n1 = stk.pop
      stk.push(n1.to_i + n2.to_i)
    end,

    Builtin.new('-') do |stk|
      # (n1 n2 -- n1-n2)
      n2 = stk.pop
      n1 = stk.pop
      stk.push(n1.to_i - n2.to_i)
    end,

    Builtin.new('*') do |stk|
      # (n1 n2 -- n1*n2)
      n2 = stk.pop
      n1 = stk.pop
      stk.push(n1.to_i * n2.to_i)
    end,

    Builtin.new('/') do |stk|
      # (n1 n2 -- n1/n2)
      n2 = stk.pop
      n1 = stk.pop
      stk.push(n1.to_i / n2.to_i)
    end,

    Builtin.new('mod') do |stk|
      # (n1 n2 -- n1%n2)
      n2 = stk.pop
      n1 = stk.pop
      stk.push(n1.to_i % n2.to_i)
    end,

    Builtin.new('/mod') do |stk|
      # (n1 n2 -- n1%n2 n1/n2)
      n2 = stk.pop
      n1 = stk.pop
      stk.push(n1.to_i % n2.to_i)
      stk.push(n1.to_i / n2.to_i)
    end,

    Builtin.new('swap') do |stk|
      # (n1 n2 -- n2 n1)
      n2 = stk.pop
      n1 = stk.pop
      stk.push(n2)
      stk.push(n1)
    end,

    Builtin.new('dup') do |stk|
      # (n -- n n)
      n = stk.pop
      stk.push(n)
      stk.push(n)
    end,

    Builtin.new('over') do |stk|
      # (n1 n2 -- n1 n2 n1)
      n2 = stk.pop
      n1 = stk.pop
      stk.push(n1)
      stk.push(n2)
      stk.push(n1)
    end,

    Builtin.new('rot') do |stk|
      # (n1 n2 n3 -- n2 n3 n1)
      n3 = stk.pop
      n2 = stk.pop
      n1 = stk.pop
      stk.push(n2)
      stk.push(n3)
      stk.push(n1)
    end,

    Builtin.new('drop') do |stk|
      stk.pop
    end,

    Builtin.new('cr') do |stk|
      puts
    end,

    Builtin.new('emit') do |stk|
      x = stk.pop
      print x.to_i.chr, ' '
    end,

    Builtin.new('spaces') do |stk|
      x = stk.pop
      x.to_i.times do
        print ' '
      end
    end,

    Builtin.new('.') do |stk|
      print stk.pop, ' '
    end
]