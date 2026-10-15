return {
  "sphamba/smear-cursor.nvim",
  opts = {
    smear_between_buffers = true,
    smear_between_neighbor_lines = true,
    scroll_buffer_space = true,
    smear_insert_mode = true,

    -- Estela visible: la cabeza llega rápido al destino y la cola se queda atrás.
    -- Con stiffness == trailing_stiffness el bloque se desliza rígido y no hay
    -- cola; hay que separarlos para que el cuadrilátero se estire.
    stiffness = 0.65,
    trailing_stiffness = 0.2,
    -- Cuántas esquinas se quedan atrás: bajo => el estirón se reparte a lo largo
    -- de toda la estela en vez de concentrarse en la punta.
    trailing_exponent = 2,
    -- Estirón inicial en sentido contrario. Es lo que hace visible el smear en
    -- movimientos de un solo carácter (en `l`/`h` las 4 esquinas están a la misma
    -- distancia del destino, así que sin anticipación no se deformarían).
    anticipation = 0.2,
    -- Más elástico => la estela tarda más en disolverse en vez de un salto seco.
    damping = 0.85,
    -- Desvanecido suave a lo largo de la cola, si no el final es invisible.
    gradient_exponent = 0.6,
    -- Chispas que hacen obvio el rastro. `particles_over_text` para que también
    -- se vean sobre el texto y no sólo en zonas vacías.
    particles_enabled = true,
    particles_over_text = false,
    particles_per_second = 300,
    particle_max_lifetime = 400,
    particle_max_initial_velocity = 14,
    particle_gravity = 0,
    min_distance_emit_particles = 0.4,

    -- Alacritty soporta `guicursor`, así que el plugin puede ocultar el cursor
    -- real mientras anima. Con hide_target_hack el bloque real se pintaba siempre
    -- en el destino (teleport) y la estela sólo se veía como un parpadeo detrás.
    hide_target_hack = false,
    never_draw_over_target = false,
  },
}
