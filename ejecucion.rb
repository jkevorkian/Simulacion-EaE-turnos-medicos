require_relative 'EaE'
class Array
  def second
    self.length <= 1 ? nil : self[1]
  end
end


UN_DIA = 1440
RANGO_M = 9

class Ejecucion
  attr_accessor :resultado
  def initialize
    resultado = [RANGO_M+1]
    #for i in 0..RANGO_M-1
    #resultado[]
    #end
    for i in 1..RANGO_M
      resultado[i] = Simulador.new(i, UN_DIA*10).run
    end
    puts "\n\n\n---------PRINTEO DE RESULTADOS FINALES-----------"
    for i in 1..RANGO_M

    puts "Sim #"+i.to_s+". M: "+i.to_s+"  PEC: "+resultado[i].first.to_s+"     PTO: "+resultado[i].second.to_s
    end
  end
end

Ejecucion.new




