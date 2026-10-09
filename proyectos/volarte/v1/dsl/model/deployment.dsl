# =============================================================================
# Modelo de Despliegue (Fuente: Draw.io Volarte v1 · L2 boundaries GCP)
# Proyectos GCP por ambiente: terpel-infra-vpc-transversal,
# terpel-gtic-apigee-AMB, terpel-gtic-front-AMB, terpel-org-col-volarte-AMB
# Propiedades usadas por el Agente Revisor:
#   "ha"          -> "true" si el nodo tiene alta disponibilidad (multi-zona)
#   "autoscaling" -> rango de instancias (min..max)
# =============================================================================

prd = deploymentEnvironment "Produccion" {

    deploymentNode "Dispositivo Android Gestionado" "Dispositivo corporativo del operario (posture Intune, perfil de trabajo)." "Android · Intune / Managed Play" "Device" {
        mobileAppInstance = containerInstance mobileApp
        ztnaAgentNode = infrastructureNode "Netskope Client" "Agente ZTNA del dispositivo; habilita el túnel solo con posture válido." "Netskope Agent" "Security"
    }

    deploymentNode "Navegador Web" "Navegador del empleado / usuario externo." "Chrome · Edge" "Device" {
        frontendWebInstance = containerInstance frontendWeb
    }

    deploymentNode "Cloudflare" "Red de borde global de Cloudflare." "Cloudflare Edge" "Edge" {
        cfEdge = infrastructureNode "Cloudflare WAF / CDN" "WAF, protección DDoS y CDN del bundle web." "Cloudflare" "Edge"
    }

    deploymentNode "Netskope Cloud" "Plataforma ZTNA SaaS." "Netskope Private Access" "Edge" {
        ztnaGateway = infrastructureNode "Netskope Private Access Gateway" "Publica el acceso privado a Apigee solo para dispositivos con posture válido." "Netskope NPA" "Edge,Security"
    }

    deploymentNode "Google Cloud Platform" "Organización GCP de Terpel." "GCP" "GCP" {

        deploymentNode "terpel-infra-vpc-transversal" "VPC compartida transversal." "Shared VPC" "VPC" {
            extLbNode = infrastructureNode "External Regional Load Balancer" "Termina TLS en el borde." "GCP Cloud Load Balancing" "LoadBalancer"
            fwNode = infrastructureNode "Firewall Palo Alto" "Inspección y NAT de tráfico norte-sur." "Palo Alto VM-Series" "Firewall"
            intLbNode = infrastructureNode "Internal Load Balancer" "Enrutamiento interno a Apigee y Cloud Run." "GCP Internal HTTP(S) LB" "LoadBalancer"
        }

        deploymentNode "terpel-gtic-apigee-prd" "Proyecto de API Management." "Apigee X" "GCPProject" {
            apigeeProxyNode = infrastructureNode "Proxy instance (Apigee)" "Puente de conexión VPC ↔ Apigee." "Compute Engine MIG" "Gateway"
            apigeeInstance = softwareSystemInstance apigee
        }

        deploymentNode "terpel-gtic-front-prd" "Proyecto de hosting de frontends." "GCP Project" "GCPProject" {
            spaBucket = infrastructureNode "Bucket SPA Volarte" "Origen estático del bundle React servido por Cloudflare CDN." "Google Cloud Storage" "Storage"
        }

        deploymentNode "terpel-org-col-volarte-prd" "Proyecto GCP de Volarte (equivalente en dev y qa)." "GCP Project" "GCPProject" {

            deploymentNode "Cloud Run · BFF" "Servicios serverless de borde de aplicación." "Cloud Run (serverless)" "CloudRun" {
                properties {
                    "autoscaling" "1..N"
                    "ha" "true"
                }
                bffWebInstance = containerInstance bffWeb
                bffMobileInstance = containerInstance bffMobile
            }

            deploymentNode "Cloud Run · Servicios de Dominio" "Servicios de dominio serverless (ingress interno, IAM Invoker)." "Cloud Run (serverless)" "CloudRun" {
                properties {
                    "autoscaling" "0..N"
                    "ha" "true"
                }
                svcUsuariosInstance = containerInstance svcUsuarios
                svcDatosMaestrosInstance = containerInstance svcDatosMaestros
                svcComercialInstance = containerInstance svcComercial
                svcOperacionInstance = containerInstance svcOperacion
                gestorDocumentalInstance = containerInstance gestorDocumental
            }

            deploymentNode "GKE" "Cómputo sostenido para optimización (P-025 PENDING)." "GKE Autopilot" "GKE" {
                svcAsignacionInstance = containerInstance svcAsignacion
            }

            deploymentNode "Cloud SQL" "Instancia PostgreSQL gestionada (CMEK). Configuración HA pendiente de confirmar." "Cloud SQL for PostgreSQL" "Database" {
                cloudSqlInstance = containerInstance cloudSql
            }

            deploymentNode "Memorystore" "Redis gestionado. Tier pendiente de confirmar (Basic = sin réplica)." "Memorystore for Redis" "Database" {
                memorystoreInstance = containerInstance memorystore
            }

            deploymentNode "Pub/Sub" "Servicio global gestionado de mensajería." "Google Cloud Pub/Sub" "Queue" {
                properties {
                    "ha" "true"
                }
                pubsubInstance = containerInstance pubsub
            }

            deploymentNode "Cloud Storage" "Bucket de documentos WORM (regional / dual-region)." "Google Cloud Storage" "Storage" {
                properties {
                    "ha" "true"
                }
                documentosGcsInstance = containerInstance documentosGcs
            }

            deploymentNode "Seguridad del Proyecto" "Servicios gestionados de seguridad." "GCP Managed Services" "Security" {
                secretManagerInstance = softwareSystemInstance secretManager
                kmsInstance = softwareSystemInstance kms
            }
        }
    }

    cfEdge -> extLbNode "Pass-through" "HTTPS · TLS 1.3"
    cfEdge -> spaBucket "Origen del bundle estático" "HTTPS"
    extLbNode -> fwNode "Reenvía tráfico" "HTTPS"
    fwNode -> intLbNode "Reenvía tráfico inspeccionado" "HTTPS"
    intLbNode -> apigeeProxyNode "Reenvía tráfico" "HTTPS"
    ztnaAgentNode -> ztnaGateway "Túnel ZTNA" "mTLS"
    ztnaGateway -> apigeeProxyNode "Acceso privado" "mTLS"
}
