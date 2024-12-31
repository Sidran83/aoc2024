require 'artii'

module Formatter

  def pretty_print(result, num, day)
    a = Artii::Base.new
    puts a.asciify("AOC -  DAY #{day} - PART #{num}")

    puts "
    ##################################
    #        Result : #{result}      #
    ##################################
        "
  end
end
