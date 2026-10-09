prd = deploymentEnvironment "Produccion" {
    deploymentNode "Google Cloud Platform" "Organización GCP." "GCP" {
        deploymentNode "Cloud Run" "Servicios serverless." "Cloud Run" {
            containerInstance api
        }
        deploymentNode "Cloud SQL" "Base de datos gestionada." "Cloud SQL for PostgreSQL" {
            containerInstance db
        }
        deploymentNode "Cloud Storage + CDN" "Hosting estático." "GCS · Cloudflare" {
            containerInstance app
        }
    }
}
