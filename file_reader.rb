class FileReader
  attr_reader :lines

  def initialize(path)
    @path = path
    @lines = split_in_two
  end

  private

  def split_in_two
    File.read(@path).split("\n\n").map { |section| section.split("\n") }
  end

  # def read_lines
  #   byebug
  #   File.read(@path).split("\n")
  # end
end
