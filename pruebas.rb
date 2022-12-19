MAX_TA = 40
MIN_TA = 9
MAX_IA = 27
DIA_DE_ALTA_FRECUENCIA = true

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

auxta = []
auxia = []
for i in 1..1000
  #puts ta
  puts ia
  auxta.append ta
  auxia.append ia
end
##PROMEDIO IASTA 20
## PROMEDIO TA 25
## PROMEDIO IAPLUS 13

#puts "\n\nPROMEDIO TA "+(auxta.sum/1000).to_s
puts "\n\nPROMEDIO IA "+(auxia.sum/1000).to_s
#puts auxia.sum/1000