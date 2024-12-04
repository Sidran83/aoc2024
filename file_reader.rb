class FileReader
  attr_reader :lines

  def initialize(path)
    @path = path
    @lines = read_lines
  end

  private

  def read_lines
    File.read(@path).split("\n")
  end
end
