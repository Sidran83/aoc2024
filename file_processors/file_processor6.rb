require 'byebug'
require_relative '../file_reader'
require_relative '../formatter'

class FileProcessor6
  include Formatter

  attr_reader :lines

  def initialize(file_path)
    @reader = FileReader.new(file_path)
    @lines =  @reader.lines
  end

  def process(part)
    part == "1" ? first_part(lines, 1) : last_part(lines, 2)
  end

  private

  def first_part(lines, one)
    byebug

    left_numbers.sort!
    right_numbers.sort!

    pretty_print(zip_and_map(left_numbers, right_numbers).sum, one)
  end

  def last_part(lines, two)

    pretty_print(left_numbers.map { |num| num * right_numbers.count(num) }.sum, 2)
  end
end
