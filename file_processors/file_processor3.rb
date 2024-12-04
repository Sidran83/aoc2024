require 'byebug'
require_relative '../file_reader'
require_relative '../formatter'

class FileProcessor3
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
    matches = lines.map { |line| line.scan(regex) }.flatten(1)
    products = matches.map { |a, b| a.to_i * b.to_i }

    pretty_print(products.sum, one)
  end

  def last_part(lines, two)
    inputs = lines.map { |line| line.scan(another_regex) }.flatten(1)
    matches = iteration_with_flag(inputs)
    products = matches.map { |match| match.scan(regex) }.flatten(1).map { |a, b| a.to_i * b.to_i }

    pretty_print(products.sum, two)
  end

  def iteration_with_flag(inputs)
    result = []
    skip = false

    inputs.each do |item|
      if item == "don't()"
        skip = true
      elsif item == "do()"
        skip = false
      elsif !skip
        result << item
      end
    end
    result
  end

  def regex
    /mul\((\d{1,3}),(\d{1,3})\)/
  end

  def another_regex
    /mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/
  end
end
