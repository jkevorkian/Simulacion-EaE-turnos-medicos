require_relative 'EaE'

UN_DIA = 1440
RANGO_M = 10

promedio_espera_en_cola = []
porcentaje_tiempo_ocioso_medicos = []



for i in 1..RANGO_M
  resultado = Simulador.new(i, UN_DIA*30).run
  #promedio_espera_en_cola[i] = resultado[0]
  #porcentaje_tiempo_ocioso_medicos[i] = resultado[1]
end

for i in 1..RANGO_M
  #puts "Sim #"+i.to_s
  #puts promedio_espera_en_cola, porcentaje_tiempo_ocioso_medicos.join(' - ')
  #puts "\n\n"
end


