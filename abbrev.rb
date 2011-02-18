#!/usr/bin/env ruby

#illustrative Ruby code to return all abbreviations for the given argument: e.g. for "abc": a, ab, abc, ac, b, c, bc

require 'rubygems'
require 'set'

#to measure performance
require 'ruby-prof'

class Abbrev
  attr_accessor :a, :C #holds initial string

  def initialize(str)
    @a = str
    @C = []
  end

  #builds all abbreviations of size n btw indexes i=0 and i=l-n+1 (l=a.size)
  def c(n)
    @C[n] = []
    if n==1
      for i in (0..a.size-1)
        @C[1][i] = a[i].chr
      end
    else
      for i in (0..a.size-n)
        @C[n][i] = append_to_each(a[i].chr, @C[n-1][i+1..a.size-1])
      end
    end
  end

  #append str to each element of the array of strings, where array is [ ["str1" "str2"] ["str3" ..] ] or ["str1" "str2"...]
  def append_to_each(str,array)
    new_array = []
    new_set = collapse(array)
    new_set.each {|s| new_array << str + s}
    new_array
  end

end

  def abbreviate
    str = ARGV[0] 
    a = Abbrev.new(str)
    puts "Abbreviations:"
    abbrev_set = Set.new

    RubyProf.start

    for j in (1..str.size) 
      a.c(j)
      abbrev_set = abbrev_set.union collapse(a.C[j])
    end
 
    #--rubyprof--   
    result = RubyProf.stop
    # Print a flat profile to text
    printer = RubyProf::FlatPrinter.new(result)
    printer.print(STDOUT, 0)
    #--rubyprof--         

    abbrev_set.each {|abbr| puts abbr}

  end

  #utility function: turns an array of arrays(a 2 dimensional array) into a one dimensional array, and removes duplicates
  #e.g. input: [["str1","str2"] ["str3, str1"]] --> returns: ["str1" "str2" "str3"]
  def collapse(array_of_arrays)
    new_set = Set.new
    array_of_arrays.each{|e| e.each {|k| new_set << k}}
    new_set
  end

  #same as ruby flatten, for implementation illustrative purposes
  def flatten_out(a)
    a.each {|x|
      a = Array.new
      if x.class!=Array
        a << e
      else
        a << flatten-out(x)
      end
    }

  end



abbreviate
