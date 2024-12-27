class FileReader
  attr_reader :lines

  def initialize(path)
    @path = path
    @lines = read_each_elem
  end

  private

  def split_in_two
    File.read(@path).split("\n\n").map { |section| section.split("\n") }
  end

  def read_lines
    File.read(@path).split("\n")
  end

  def read_each_elem
    File.read(@path).split("\n").map { |line| line.split('') }
  end
end
