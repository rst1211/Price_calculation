class Calculate
    attr_accessor :total_price
    def initialize()
        total_price=0
    end
    def take_inpute
        puts "Please enter all the items purchased separated by a comma"
        input=gets.chomp
        input=input.delete(' ').split(',')
        freq_cnt=count_frequency(input)
        
    end
    def count_frequency(input)
        freq=Hash.new(0)
        input.each{ |key| freq[key]+=1 }
        freq
    end
end

c1=Calculate.new
c1.take_inpute