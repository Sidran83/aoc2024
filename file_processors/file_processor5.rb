require 'byebug'
require_relative '../file_reader'
require_relative '../formatter'

class FileProcessor5
  include Formatter

  def initialize(file_path)
    @reader = FileReader.new(file_path)
    @rules =  @reader.lines[0]
    @sequences = @reader.lines[1]
    @counter = 0
  end

  def process(part)
    part == "1" ? first_part(@rules, @sequences, 1) : last_part(@lines, 2)
  end

  private

  def first_part(rules, sequences, one)
    positions = sequences.map { |sequence| sequence.split(",").each_with_index.to_h }
    couples = rules.map { |rule| rule.split("|").map(&:to_i) }

    positions.each do |position|
      if sequence_respects_rules?(position, couples)
        @counter += position.keys[(position.keys.count / 2.to_f).ceil - 1].to_i
      end
    end

    pretty_print(@counter, one)
  end

  def sequence_respects_rules?(position, couples)
    couples.all? do |before, after|
      ordered_couple?(position, before, after) || number_not_present?(position, before, after)
    end
  end

  def number_not_present?(position, before, after)
    (position[before.to_s].nil? || position[after.to_s].nil?)
  end

  def ordered_couple?(position, before, after)
    (position[before.to_s] && position[after.to_s] && position[before.to_s] < position[after.to_s])
  end

  def last_part(lines, two)

    pretty_print(lines, two)
  end

end
