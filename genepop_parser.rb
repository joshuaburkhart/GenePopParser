#!/usr/bin/ruby
#Usage: ruby parser.rb <genepop file>

genepop_filename = ARGV[0]
out_filename = "genepop_summary.csv"

genepop_filehandl = File.open(genepop_filename,"r")
out_filehandl = File.open(out_filename,"w")

next_pop = false
marker_name_ary = nil
iter = 0
print "reading \'#{genepop_filename}\'..."
while(line = genepop_filehandl.gets)
    if(line.match(/^([0-9]+_[0-9]+,)+[0-9]+_[0-9]+$/))
        marker_name_ary = line.strip.split(',')
        out_filehandl.puts ",#{marker_name_ary.join(",,,,")}"
        out_filehandl.puts ",#{"1,2,3,4,"*marker_name_ary.size}"
    elsif(line.match(/^pop$/) || next_pop == true)
        next_pop = false
        pop_ary = Array.new
        idx = 0
        while((pop_line = genepop_filehandl.gets) && !pop_line.match(/^pop$/))
            if(idx == 0)
                pop_line.match(/^([a-zA-Z0-9]+)/)
                indv_name = $1
                out_filehandl.print "#{indv_name},"
            end
            exprsn = pop_line.scan(/\s+([0-9]{4})/)
            pop_ary[idx] = exprsn
            idx += 1
        end
        if(pop_ary.size > 0)
            for i in 0..(pop_ary[0].size - 1) 
                ones = 0.0
                twos = 0.0
                tres = 0.0
                fors = 0.0
                for j in 0..(pop_ary.size - 1)
                    ones += pop_ary[j][i][0].count("1")
                    twos += pop_ary[j][i][0].count("2")
                    tres += pop_ary[j][i][0].count("3")
                    fors += pop_ary[j][i][0].count("4")
                end
                out_filehandl.print "#{ones/pop_ary.size},#{twos/pop_ary.size},#{tres/pop_ary.size},#{fors/pop_ary.size}"
            end
            out_filehandl.puts
        end
        next_pop = true
    else
        if(!line.match(/^Stacks.*$/))
           puts "Unused line: #{line}"
        end
    end
    print "."
    $stdout.flush
    iter += 1
end
puts
genepop_filehandl.close
out_filehandl.close
puts "Done. Output written to \'#{out_filename}\'"
