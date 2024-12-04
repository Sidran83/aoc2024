require 'artii'

module Formatter

  def pretty_print(result, num)
    a = Artii::Base.new
    puts a.asciify("AOC - PART #{num}")

    puts "
    ##################################
    #        Result : #{result}      #
    ##################################
        "
  end
end
