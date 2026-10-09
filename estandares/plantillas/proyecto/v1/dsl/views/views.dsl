systemContext sistema "L1_System_Context" "L1 · Contexto del sistema." {
    include *
    autoLayout tb
}
container sistema "L2_Containers" "L2 · Contenedores." {
    include *
    autoLayout lr
}
deployment sistema prd "DEP_Produccion" "Despliegue en producción." {
    include *
    autoLayout lr
}
