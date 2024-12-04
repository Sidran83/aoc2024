require 'byebug'
require_relative '../file_reader'
require_relative '../formatter'

class FileProcessor2
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

    lines.each do |line|
      numbers = line.split.map(&:to_i)
      counter += 1 if increasing?(numbers) || decreasing?(numbers)
    end

    pretty_print(counter, one)
  end

  def last_part(lines, two)
    counter = 0

    lines.each do |line|
      numbers = line.split.map(&:to_i)

      if increasing?(numbers) || decreasing?(numbers)
        counter += 1
      else
        numbers.each_with_index do |number, index|
          reduced_numbers = numbers.reject.with_index { |_, i| i == index }

          if increasing?(reduced_numbers) || decreasing?(reduced_numbers)
            counter += 1
            break
          end
        end
      end
    end

    pretty_print(counter, two)
  end

  def increasing?(numbers)
    numbers.each_cons(2).all? { |a, b| a < b && (a - b).abs < 4 }
  end

  def decreasing?(numbers)
    numbers.each_cons(2).all? { |a, b| a > b && (a - b).abs < 4 }
  end
end
