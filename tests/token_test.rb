load 'forth.rb'

class TokensTest
  def self.test1
    scanner = Scanner.new('23 34 45 + swap - . ." We are done "')
    while scanner.has_more? do
      word = scanner.next
      p word
      if Tokens.integer? word
        p 'INT'
      elsif Tokens.string_open? word
        p 'STRING[[ '
      elsif Tokens.string_close? word
        p ' ]]'
      elsif Tokens.symbol? word
        p 'SYMBOL'
      else
        p 'UNKNOWN'
      end
    end
  end
end

TokensTest.test1

