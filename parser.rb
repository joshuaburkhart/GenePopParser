#!/usr/bin/ruby
#Usage: ruby parser.rb <genepop file>

genepop_filename = ARGV[0]

genepop_filehandl = File.open(genepop_filename,"r")
out_filehandl = File.open("summary.txt","w")

next_pop = false
marker_name_ary = nil 
while(line = genepop_filehandl.gets)
    if(line.match(/^([0-9]+_[0-9]+,)+[0-9]+_[0-9]+$/))
        marker_name_ary = line.strip.split(',')
        out_filehandl.puts "\t#{marker_name_ary.join("\t\t\t\t\t\t")}"
        out_filehandl.puts "\t#{"1,2,3,4\t\t\t\t\t\t"*marker_name_ary.size}"
    elsif(line.match(/^pop$/) || next_pop == true)
        next_pop = false
        pop_ary = Array.new
        idx = 0
        while((pop_line = genepop_filehandl.gets) && !pop_line.match(/^pop$/))
            if(idx == 0)
                pop_line.match(/^([a-zA-Z0-9]+)/)
                indv_name = $1
                out_filehandl.print "#{indv_name}\t"
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
                    puts "pop_ary.size: #{pop_ary.size}"
                    puts "pop_ary[0].size: #{pop_ary[0].size}"
                    puts "i: #{i}"
                    puts "j: #{j}"
                    ones += pop_ary[j][i][0].count("1")
                    twos += pop_ary[j][i][0].count("2")
                    tres += pop_ary[j][i][0].count("3")
                    fors += pop_ary[j][i][0].count("4")
                end
                out_filehandl.print "#{ones/pop_ary.size},#{twos/pop_ary.size},#{tres/pop_ary.size},#{fors/pop_ary.size}\t"
            end
            out_filehandl.puts
        end
        next_pop = true
    else
        puts "Unused line: #{line}"
    end
end
genepop_filehandl.close
out_filehandl.close
