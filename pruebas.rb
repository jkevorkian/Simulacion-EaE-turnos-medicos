#require_relative 'EaE'
#require 'rubyvis'

#(Math::E**((-1/2)*(((Math.log x)-621.1868)/357.7142)**2))/(x*357.7142*(6.2838)**(1/2))  #Log-normal
#(Math::E**((-1/2)*((x-615.9447)/325.4896)**2))/(325.4896*(6.2838)**(1/2)) #normal

HIGH_VALUE = 99999


class Prueba
  attr_accessor :m
  attr_accessor :tps

  def initialize
    @m = 5
    @tps = [HIGH_VALUE,HIGH_VALUE,HIGH_VALUE,HIGH_VALUE,HIGH_VALUE]
    #for i in 0..m-1
    #  @tps[i] = HIGH_VALUE
    #end
  end

  def menor_tps
    i = 0
    j = 0


    while j<m

      puts @tps.join ' '
      puts i
      unless tps[i] <= tps[j]
        i = j
      end
      j = j + 1
    end
    i
  end
end


panda = Prueba.new
puts panda.menor_tps




