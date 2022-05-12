load 'forth.rb'

class ScannerTest
  def self.test1
    scanner = Scanner.new('23 34 45 + swap - . ." We are done "')
    p scanner.words
    while scanner.has_more? do
      p scanner.next
    end
  end
end

ScannerTest.test1
