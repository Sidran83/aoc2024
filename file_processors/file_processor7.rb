require 'byebug'
require_relative '../file_reader'
require_relative '../formatter'

class FileProcessor7
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
    counter = 0
    operators = %w(+ *)

    lines.each do |line|
      target_sum, numbers = line.split(": ")
      numbers = numbers.split.map(&:to_i)
      target_sum = target_sum.to_i
      combinations = operators.repeated_permutation(numbers.size - 1).to_a

      results = combinations.each_with_object([]) { |ops, arr| arr << evaluate_left_to_right(numbers, ops) }

      counter += target_sum if results.include?(target_sum)
    end
    pretty_print(counter, one, 7)
  end

  def evaluate_left_to_right(numbers, operators)
    result = numbers.first
    operators.each_with_index do |op, index|
      case op
      when "+"
        result += numbers[index + 1] unless  numbers[index + 1].nil?
      when "*"
        result *= numbers[index + 1] unless numbers[index + 1].nil?
      end
    end
    result
  end
end
