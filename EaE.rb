#require 'gnuplot'

MAX_TA = 90
MAX_IA = 60

HIGH_VALUE = 99999
DIA_DE_ALTA_FRECUENCIA = false

class Simulador
  attr_accessor :m
  attr_accessor :tf
  attr_accessor :t
  attr_accessor :sps
  attr_accessor :sta
  attr_accessor :nt
  attr_accessor :sto
  attr_accessor :ns     #ESTADO
  attr_accessor :i
  attr_accessor :tpll
  attr_accessor :tps
  attr_accessor :ito
  def initialize(cantidad_medicos, tiempo_final)#CONDICIONES INICIALES


    @m= cantidad_medicos   #Variable de control M

    @tf = tiempo_final      #Tiempo simulado a partir del cual se termina la simulación, sirve para acotar el tiempo de ejecución
    @t = 0                  #Tiempo actual durante la simulacion, en minutos
    @sps = 0
    @sta = 0
    @nt = 0
    @sto = []
    for i in 0..m-1
      @sto[i] = 0
    end

    @ns = 0

    @i = 0
    @tpll = 0
    @tps = []
    for i in 0..m-1
      @tps[i] = HIGH_VALUE
    end

    @ito= []
    for i in 0..m-1
      @ito[i] = 0
    end

  end

  def run

    while @t<@tf
      i = menor_tps
      puts "\n\n\nnueva iteracion\n"
      puts "Estado de los medicos:\n["+@tps.join(' - ')+"]"
      puts "t: "+@t.to_s, "i: " + i.to_s, "menor tps: " + @tps[i].to_s, "tpll: " + @tpll.to_s

      if @tpll<=@tps[i]
        puts "\nprox evento es llegada: "
        llegada
      else
        puts "\nprox evento es salida: "
        salida
      end
    end
    calculo_e_impresion_resultados

  end
  def llegada
      @sps = @sps + (@tpll-@t)*@ns
      @t = @tpll
      @tpll = @t + ia
      @ns = @ns + 1
      @nt = @nt + 1
      puts "nuevo tpll es: "+@tpll.to_s, "NS ahora: " + @ns.to_s
      if @ns<=@m
        @i = busco_medico
        @sto[i] = @sto[i] + @t - @ito[i]
        aux_ta = ta
        @tps[i] = @t + aux_ta
        @sta = @sta + aux_ta
        puts "el medico numero "+@i.to_s+" estaba libre! \nsu ta es "+aux_ta.to_s+" y entonces su nuevo tps es "+@tps[i].to_s
      end
  end

  def salida
      @sps = @sps + (@tps[i] - @t)*@ns
      @t = @tps[i]
      @ns = @ns - 1
      if @ns>=@m
        aux_ta = ta
        @tps[i] = @t + aux_ta
        @sta = @sta + aux_ta
      else
        @ito[i] = @t
        @tps[i] = HIGH_VALUE
      end
  end

    #FUNCIONES AUXILIARES
  def menor_tps
    i = 0
    j = 0

    while j<@m
      if not @tps[i]<= @tps[j]
        i=j
      end
      j = j + 1
    end
    i
  end

  def busco_medico
    i = 0
    j = 0
    while j < @m
      if @tps[j] == HIGH_VALUE
        if @tps[i] == HIGH_VALUE
          if not @sto[i] >= @sto[j]
            i = j
          end
        else
          i = j
        end
      end

      j = j + 1
    end
    i
  end
  def ta
    x = rand(MAX_TA*60)
    y = rand(0.1)
    ordenada_de_x = Math::E**((-0.5)*((x-1307.7058)/413.6817)**2)/413.6817*(6.2838**0.5)

    while y > ordenada_de_x
      x = rand(MAX_TA*60)
      y = rand(0.1)
      ordenada_de_x = (Math::E**((-0.5)*((x-1307.7058))/413.6817)**2)/413.6817*(6.2838**0.5)
      #puts "x: ",x,"\n","y: ",y, "\n", "ordenada: ",ordenada_de_x, "\n\n"
    end

    x/60
    #return 413.6817*(Math.sqrt((Math.log(r*1036.996968))/-0.5))+1307.7058  #la inversa no tiene valores reales para el dominio
  end

  def ia

    x = rand(MAX_IA*60)
    y = rand(0.1)
    if DIA_DE_ALTA_FRECUENCIA
      ordenada_de_x = Math::E**((-0.5)*((x-1307.7058)/413.6817)**2)/413.6817*(6.2838**0.5)
    else   ordenada_de_x = (Math::E**((-1/2)*((x-615.9447)/325.4896)**2))/(325.4896*(6.2838)**(1/2))
    end

    while y > ordenada_de_x
      x = rand(MAX_IA*60)
      y = rand(0.1)
      if DIA_DE_ALTA_FRECUENCIA
        ordenada_de_x = Math::E**((-0.5)*((x-1307.7058)/413.6817)**2)/413.6817*(6.2838**0.5)
      else   ordenada_de_x = (Math::E**((-1/2)*((x-615.9447)/325.4896)**2))/(325.4896*(6.2838)**(1/2))
      end
      #puts "x: ",x,"\n","y: ",y, "\n", "ordenada: ",ordenada_de_x, "\n\n"
    end

    x/60   #el retorno se divide por 60 para que el resultado este en minutos
  end

  def calculo_e_impresion_resultados
    #CALCULO DE RESULTADOS
    pec = (@sps-@sta)/@nt
    poc = []
    for i in 0..@m-1
      poc[i] = (@sto[i]*100)/@t
    end

    #IMPRESION DE RESULTADOS
    puts 'Cantidad de medicos: ',@m , 'pec:', pec,"\n", 'poc[i]: ', poc.join(' '), "\n"
  end

end



Simulador.new(8, 1440*30).run

