require 'byebug'
require_relative '../file_reader'
require_relative '../formatter'

class FileProcessor4
  include Formatter

  def initialize(file_path)
    @reader = FileReader.new(file_path)
    @lines =  @reader.lines
    @counter = 0
  end

  def process(part)
    part == "1" ? first_part(@lines, 1) : last_part(@lines, 2)
  end

  private

  def first_part(lines, one)
    horizontal_count(lines)
    vertical_count(lines)
    diagonal_count(lines)

    pretty_print(@counter, one)
  end

  def diagonal_count(lines)
    diagonals = diagonal_transformer(lines).map(&:join)

    diagonals.each do |diagonal_line|
      @counter += horizontal_forward_scan(diagonal_line)
      @counter += horizontal_backward_scan(diagonal_line)
    end
  end

  def vertical_count(lines)
    vertical_lines = transposer(lines)

    vertical_lines.each do |vertical_line|
      @counter += horizontal_forward_scan(vertical_line)
      @counter += horizontal_backward_scan(vertical_line)
    end
  end

  def horizontal_count(lines)
    lines.each do |line|
      @counter += horizontal_forward_scan(line)
      @counter += horizontal_backward_scan(line)
    end
  end

  def last_part(lines, two)
    pretty_print(products.sum, two)
  end

  def horizontal_forward_scan(line)
    line.scan("XMAS").count
  end

  def horizontal_backward_scan(line)
    line.scan("SAMX").count
  end

  def transposer(lines)
    lines.map { |line| line.split('') }.transpose.map(&:join)
  end

  def diagonal_transformer(lines)
    matrix = lines.map { |line| line.split('') }
    diagonals = []

    (0...matrix.size).each do |row|
      diagonal = []
      (0...[matrix.size - row, matrix[0].size].min).each do |i|
        diagonal << matrix[row + i][i]
      end
      diagonals << diagonal
    end

    (1...matrix[0].size).each do |col|
      diagonal = []
      (0...[matrix.size, matrix[0].size - col].min).each do |i|
        diagonal << matrix[i][col + i]
      end
      diagonals << diagonal
    end

    (0...matrix.size).each do |row|
      diagonal = []
      (0...[row + 1, matrix[0].size].min).each do |i|
        diagonal << matrix[row - i][i]
      end
      diagonals << diagonal
    end

    (1...matrix[0].size).each do |col|
      diagonal = []
      (0...[matrix.size, matrix[0].size - col].min).each do |i|
        diagonal << matrix[matrix.size - 1 - i][col + i]
      end
      diagonals << diagonal
    end

    diagonals
  end
end
