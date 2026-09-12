object puenteDeBrooklyn {
  method puedePasar(mensajero) = mensajero.peso() <= 1000
}

object laMatrix {
  method puedePasar(mensajero) = mensajero.puedeHacerLlamadas()
}

class Paquete {
  var precio
  var pagado = 0

  method initialize() {
    precio = 50
  }

  method pagar(monto) {
    pagado = pagado + monto
  }

  method estaPago() = pagado >= precio

  method puedeSerEntregadoPor(mensajero) = self.estaPago()
}

class PaqueteConDestino {
  var destino = puenteDeBrooklyn
  const precio = 50
  var pagado = 0

  method initialize() {}

  method configurarDestino(destinoInicial) {
    destino = destinoInicial
  }

  method pagar(monto) {
    pagado = pagado + monto
  }

  method estaPago() = pagado >= precio

  method puedeSerEntregadoPor(mensajero) =
    self.estaPago() && mensajero.puedeLlegar(destino)
}

class Paquetito {
  method precio() = 0

  method estaPago() = true

  method pagar(monto) {}

  method puedeSerEntregadoPor(mensajero) = true
}

class PaquetonViajero {
  var destinos = []
  var pagado = 0

  method initialize() {}

  method configurarDestinos(destinosIniciales) {
    destinos = destinosIniciales
  }

  method precio() = destinos.size() * 100

  method pagar(monto) {
    pagado = pagado + monto
  }

  method estaPago() = pagado >= self.precio()

  method puedeSerEntregadoPor(mensajero) =
    self.estaPago() && destinos.all { destino => mensajero.puedeLlegar(destino) }
}

class Roberto {
  var modo = "bicicleta"
  var acoplados = 0
  var pesoPropio = 0

  method initialize() {}

  method configurarPeso(peso) {
    pesoPropio = peso
  }

  method viajarEnBicicleta() {
    modo = "bicicleta"
    acoplados = 0
  }

  method viajarEnCamion(cantidadDeAcoplados) {
    modo = "camion"
    acoplados = cantidadDeAcoplados
  }

  method peso() = if (modo == "bicicleta") pesoPropio + 5 else pesoPropio + acoplados * 500

  method puedeHacerLlamadas() = false

  method puedeLlegar(destino) = destino.puedePasar(self)

  method puedeEntregar(paquete) = paquete.puedeSerEntregadoPor(self)
}

object chuckNorris {
  method peso() = 80

  method puedeHacerLlamadas() = true

  method puedeLlegar(destino) = destino.puedePasar(self)

  method puedeEntregar(paquete) = paquete.puedeSerEntregadoPor(self)
}

class Neo {
  var tieneCredito = false

  method initialize() {}

  method configurarCredito(credito) {
    tieneCredito = credito
  }

  method peso() = 0

  method puedeHacerLlamadas() = tieneCredito

  method puedeLlegar(destino) = destino.puedePasar(self)

  method puedeEntregar(paquete) = paquete.puedeSerEntregadoPor(self)
}

class Mensajeria {
  const empleados = []
  const pendientes = []
  var facturacion = 0

  method contratar(mensajero) {
    empleados.add(mensajero)
  }

  method despedir(mensajero) {
    empleados.remove(mensajero)
  }

  method despedirATodos() {
    empleados.clear()
  }

  method esGrande() = empleados.size() > 2

  method primerEmpleadoPuedeEntregar(paquete) =
    !empleados.isEmpty() && empleados.first().puedeEntregar(paquete)

  method pesoDelUltimoMensajero() = empleados.last().peso()

  method puedeEntregar(paquete) =
    empleados.any { empleado => empleado.puedeEntregar(paquete) }

  method mensajerosQuePuedenEntregar(paquete) =
    empleados.filter { empleado => empleado.puedeEntregar(paquete) }

  method tieneSobrepeso() {
    if (empleados.isEmpty()) return false
    return self.pesoTotal() / empleados.size() > 500
  }

  method pesoTotal() {
    var total = 0
    empleados.forEach { empleado => total = total + empleado.peso() }
    return total
  }

  method enviar(paquete) {
    if (self.puedeEntregar(paquete)) {
      facturacion = facturacion + paquete.precio()
      return true
    }
    pendientes.add(paquete)
    return false
  }

  method enviarTodos(paquetes) {
    paquetes.forEach { paquete => self.enviar(paquete) }
  }

  method enviarPendienteMasCaro() {
    if (pendientes.isEmpty()) return false
    var masCaro = pendientes.first()
    pendientes.forEach { paquete =>
      if (paquete.precio() > masCaro.precio()) masCaro = paquete
    }
    pendientes.remove(masCaro)
    if (self.enviar(masCaro)) return true
    return false
  }

  method cantidadDePendientes() = pendientes.size()

  method facturacion() = facturacion
}

object mensajeros {
  method roberto(peso) {
    const roberto = new Roberto()
    roberto.configurarPeso(peso)
    return roberto
  }

  method neo(conCredito) {
    const neo = new Neo()
    neo.configurarCredito(conCredito)
    return neo
  }
}
