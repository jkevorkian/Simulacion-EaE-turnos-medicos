#require 'gnuplot'

#ESTAS COTAS SON PARA EL METODO DEL RECHAZO
MAX_TA = 40
MAX_IA = 30

HIGH_VALUE = 99999
DIA_DE_ALTA_FRECUENCIA = true
CHEATS = true
LOGGEAR = false

#FDP_TA = (Math::E**((-1/2)*((Math.log(x)-1331.5949)/369.7252)**2))/(x*369.7252*(6.2838)**(1/2))
#FDP_IASta = (Math::E**((-1/2)*((Math.log(x)-670.8931)/318.5512)**2))/(x*318.5512*(6.2838)**(1/2))
#FDP_IAPlus = (Math::E**((-1/2)*((Math.log(x)-515.1173)/341.4035)**2))/(x*341.4035*(6.2838)**(1/2))

class Simulador
  attr_accessor :m
  attr_accessor :tf
  attr_accessor :t
  #attr_accessor :sps
  attr_accessor :stll
  attr_accessor :sts
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
    #@sps = 0
    @stll = 0
    @sts = 0
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
    corriendo = true
    vaciando = false
      puts "\n\n\n/-/-/-/-/-/ NUEVA SIMULACION /-/-/-/-/-/"
    while (vaciando || corriendo)
      if @t>@tf
        corriendo = false
        vaciando = true
        @tpll = HIGH_VALUE
      end

      @i = menor_tps
      if LOGGEAR
        puts "\n\n\nnueva iteracion\n"
      end
      if LOGGEAR
        puts "Estado de los medicos:\n["+@tps.join(' - ')+"]"
      end
      if LOGGEAR
        puts "t: "+@t.to_s,"tf: "+@tf.to_s, "nuevo i: " + @i.to_s, "menor tps: " + @tps[@i].to_s, "tpll: " + @tpll.to_s
        if @t>0
          puts "pec: "+((@sts - @stll - @sta)/@nt).to_s, "pto prom: "+((((@sto.sum)/@m) * 100)/@t).to_s
        end
      end

      if @tpll<=@tps[@i]
        if LOGGEAR
          puts "\nprox evento es llegada: "
        end
        llegada
      else
        if LOGGEAR
          puts "\nprox evento es salida: "
        end
        salida
      end

      if ns==0 && vaciando
        vaciando = false
      end
    end
    calculo_e_impresion_resultados

  end
  def llegada
     #@sps = @sps + (@tpll-@t)*@ns
      @t = @tpll

      aux_ia = ia
      @tpll = @t + aux_ia
      @stll = @stll + @t
      @ns = @ns + 1
      @nt = @nt + 1
      if LOGGEAR
        puts "el tiempo avanza, t: "+@t.to_s, "NS ahora: " + @ns.to_s, "ia es: "+aux_ia.to_s+", entonces nuevo tpll es: "+@tpll.to_s,"stll: "+@stll.to_s
      end
      if @ns<=@m
        @i = busco_medico
        @sto[@i] = @sto[@i] + @t - @ito[@i]
        aux_ta = ta
        @tps[@i] = @t + aux_ta
        @sta = @sta + aux_ta
        if LOGGEAR
          puts "el medico numero "+@i.to_s+" estaba libre! \nsu ta es "+aux_ta.to_s+" y entonces su nuevo tps es "+@tps[@i].to_s, "nuevo sta es: "+@sta.to_s
        end
      end
  end

  def salida
    if LOGGEAR
      puts "i:"+@i.to_s
    end
    #@sps = @sps + (@tps[@i] - @t)*@ns
      @t = @tps[@i]
      @ns = @ns - 1
      @sts = @sts + @t
      if LOGGEAR
        puts "NS ahora: "+@ns.to_s, "sts: "+@sts.to_s
      end
      if @ns>=@m
        aux_ta = ta
        @tps[i] = @t + aux_ta
        @sta = @sta + aux_ta
        if LOGGEAR
          puts "todavia hay gente esperando en la fila!\nnuevo tps del medico "+@i.to_s+": "+@tps[@i].to_s+". sta: "+@sta.to_s
        end
      else
        @ito[@i] = @t
        @tps[@i] = HIGH_VALUE
        if LOGGEAR
          puts "no hay nadie mas en la fila!\nel nuevo ito del medico numero "+@i.to_s+" es: "+@ito[@i].to_s+" y su tps es entonces "+@tps[@i].to_s
        end
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
    ordenada_de_x = (Math::E**((-1/2)*((x-1598.7308)/584.3439)**2))/(584.3439*(6.2838)**(1/2))

    while y >= ordenada_de_x
      x = rand(MAX_TA*60)
      y = rand(0.1)
      ordenada_de_x = (Math::E**((-1/2)*((x-1598.7308)/584.3439)**2))/(584.3439*(6.2838)**(1/2))
      #if LOGGEAR
      # puts "x: ",x,"\n","y: ",y, "\n", "ordenada: ",ordenada_de_x, "\n\n"
    end

    x/60
    #return 413.6817*(Math.sqrt((Math.log(r*1036.996968))/-0.5))+1307.7058  #la inversa no tiene valores reales para el dominio
  end

  def ia

    x = rand(MAX_IA*60)
    y = rand(0.1)
    if DIA_DE_ALTA_FRECUENCIA
      ordenada_de_x = (420.0000/2.0000)*((x/2.0000)**(420.0000-1))*((1+(x/2.0000)**420.0000)**(-2))
    else
      ordenada_de_x = (Math::E**((-1/2)*((x-1448.9089)/477.7157)**2))/(477.7157*(6.2838)**(1/2))
    end

    while y >= ordenada_de_x
      x = rand(MAX_IA*60)
      y = rand(0.1)
      if DIA_DE_ALTA_FRECUENCIA
        ordenada_de_x = (420.0000/2.0000)*((x/2.0000)**(420.0000-1))*((1+(x/2.0000)**420.0000)**(-2))
      else
        ordenada_de_x = (Math::E**((-1/2)*((x-1448.9089)/477.7157)**2))/(477.7157*(6.2838)**(1/2))
      end
      #if LOGGEAR
      # puts "x: ",x,"\n","y: ",y, "\n", "ordenada: ",ordenada_de_x, "\n\n"
    end

    x/60   #el retorno se divide por 60 para que el resultado este en minutos
  end

  def calculo_e_impresion_resultados
    #CALCULO DE RESULTADOS
    #pec = (@sps-@sta)/@nt
    pec = (@sts - @stll - @sta)/@nt
    pto = []
    for i in 0..@m-1
      pto[i] = (@sto[i]*100)/@t
    end
    #pto = (((@sto.sum)/@m) * 100)/@t

    #IMPRESION DE RESULTADOS

    puts "\n\n\n/-/-/-/-/-/ RESULTADOS /-/-/-/-/-/","Cantidad de medicos: "+ @m.to_s , "PEC:"+pec.to_s, "PTO de cada medico respectivamente: \n["+ pto.join(' - ') + "]\n"
    return [pec, pto]
  end

end



#Simulador.new(1, 1440*6*30).run

