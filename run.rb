require_relative 'file_reader'

Dir[File.join(__dir__, 'file_processors', '*.rb')].each { |file| require_relative file }

if ARGV.length != 3
  puts "Usage: ruby run.rb <FileProcessorClass> <input_file> <puzzle_part>"
  exit 1
end

file_processor_class_name = ARGV[0]
input_file_path = ARGV[1]
puzzle_part = ARGV[2]

begin
  file_processor_class = Object.const_get(file_processor_class_name)
rescue NameError
  puts "Class #{file_processor_class_name} not found!"
  exit 1
end

processor = file_processor_class.new(input_file_path)
processor.process(puzzle_part)

# arg à envoyer à la méthode processor si le puzzle est différent pour les 2 parties
# input_file_path.split(".")[-2]
