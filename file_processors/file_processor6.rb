require 'byebug'
require_relative '../file_reader'
require_relative '../formatter'

class FileProcessor6
  include Formatter

  attr_accessor :lines, :itinerary, :run

  def initialize(file_path)
    @reader = FileReader.new(file_path)
    @lines =  @reader.lines
    @itinerary = Hash.new
    @run = true
  end

  def process(part)
    part == "1" ? first_part(1) : last_part(2)
  end

  private

  def first_part(one)
    while @run
      find_the_arrow(lines)
      find_itinerary
    end
    byebug
  end

  def find_itinerary
    if itinerary[:direction] == "up"
      going_up
    elsif itinerary[:direction] == "right"
      going_right
    elsif itinerary[:direction] == "down"
      going_down
    elsif itinerary[:direction] == "left"
      going_left
    end
  end

  def check_last_direction(line, direction)
    if direction == "left"
      @run = false unless line[0..itinerary[:elem_index]].include?("#")
      pp @run
    elsif direction == "right"
      @run = false unless line[itinerary[:elem_index]..(line.length - 1)].include?("#")
      pp @run
    end
  end

  def going_left
    line = lines[itinerary[:line_index]]
    counter = itinerary[:elem_index]
    line[itinerary[:elem_index]] = "X"
    check_last_direction(line, "left")

    while counter >= 0
      if line[counter - 1] == "#"
        break
      elsif line[counter - 1] != "#" && line[counter - 2] == "#"
        line[counter - 1] = "^"
      else
        line[counter - 1] = "X"
      end
      counter -= 1
    end

    transposer(line, "horizontal")
  end

  def going_down
    line = lines.transpose[itinerary[:line_index]]
    counter = itinerary[:elem_index]
    line[itinerary[:elem_index]] = "X"
    check_last_direction(line, "right")

    while counter < line.length
      if line[counter + 1] == "#"
        break
      elsif line[counter + 1] != "#" && line[counter + 2] == "#" && (counter + 2) < line.length
        line[counter + 1] = "<"
      elsif (counter + 2) < line.length
        line[counter + 1] = "X"
      end
      counter += 1
    end
    transposer(line, "vertical")
  end

  def going_right
    line = lines[itinerary[:line_index]]
    counter = itinerary[:elem_index]
    line[itinerary[:elem_index]] = "X"
    check_last_direction(line, "right")

    while counter < line.length
      if line[counter + 1] == "#"
        break
      elsif line[counter + 1] != "#" && line[counter + 2] == "#" && (counter + 2) < line.length
        line[counter + 1] = "v"
      elsif (counter + 2) < line.length
        line[counter + 1] = "X"
      end
      counter += 1
    end
    transposer(line, "horizontal")
  end

  def going_up
    line = lines.transpose[itinerary[:line_index]]
    counter = itinerary[:elem_index]
    line[itinerary[:elem_index]] = "X"
    check_last_direction(line, "left")

    while counter >= 0
      if line[counter - 1] == "#"
        break
      elsif line[counter - 1] != "#" && line[counter - 2] == "#"
        line[counter - 1] = ">"
      else
        line[counter - 1] = "X"
      end
      counter -= 1
    end
    transposer(line, "vertical")
  end

  def transposer(line, direction)
    if direction == "vertical"
      transposed = lines.transpose
      transposed[itinerary[:line_index]] = line
      @lines = transposed.transpose
    else
      @lines[itinerary[:line_index]] = line
    end
  end

  def find_the_arrow(lines)
    if ((%w(^ v) & lines.flatten)).any?
      get_arrow(lines.transpose, "vertical")
    elsif ((%w(< >) & lines.flatten)).any?
      get_arrow(lines, "horizontal")
    else
      STDERR.puts "NO ARROW IN THE MATRIX"
      @run = false
    end
  end

  def get_arrow(lines, direction)
    lines.each_with_index do |line, l_index|
      if direction == "vertical"
        populate_hash(line, l_index) if ((%w(^ v) & line)).any?
      elsif direction == "horizontal"
        populate_hash(line, l_index) if ((%w(< >) & line)).any?
      end
    end
  end

  def populate_hash(line, l_index)
    line.each_with_index do |elem, index|
      if %w(^ v < >).include?(elem)
        case elem
        when "^"
          @itinerary[:direction] = "up"
        when "v"
          @itinerary[:direction] = "down"
        when "<"
          @itinerary[:direction] = "left"
        when ">"
          @itinerary[:direction] = "right"
        end

        @itinerary[:line_index] = l_index
        @itinerary[:elem_index] = index
      end
    end
  end

  def last_part(lines, two)
  end
end

