resource "kubernetes_stateful_set" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = "rabbitmq-solaborate"
  }

  spec {
    replicas = 2
    service_name = "rabbitmq-solaborate-service"
    selector {
      match_labels = {
        app = "rabbitmq"
      }
    }

    template {
      metadata {
        labels = {
          app = "rabbitmq"
        }
       
        annotations = {}
      }

      spec {
        service_account_name = "rabbitmq"
        container {
          name  = "rabbitmq"
          image = "rabbitmq:latest"  
          image_pull_policy = "IfNotPresent"

          args = [
            "--config.file=/etc/config/rabbitmq.yml",
            "--storage.tsdb.path=/data",
            "--web.console.libraries=/etc/rabbitmq/console_libraries",
            "--web.console.templates=/etc/rabbitmq/consoles",
            "--web.enable-lifecycle",
          ]

          port {
            container_port = 9090
          }

          resources {
            limits = {
              cpu    = "200m"
              memory = "1000Mi"
            }

            requests = {
              cpu    = "200m"
              memory = "1000Mi"
            }
          }

          volume_mount {
            name       = "config-volume"
            mount_path = "/etc/config"
          }

          volume_mount {
            name       = "rabbitmq-data"
            mount_path = "/data"
            sub_path   = ""
          }

          readiness_probe {
            http_get {
              path = "/-/ready"
              port = 9090
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
          }

          liveness_probe {
            http_get {
              path   = "/-/healthy"
              port   = 9090
              scheme = "HTTPS"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 30
          }
        }

        termination_grace_period_seconds = 300

        volume {
          name = "config-volume"

          config_map {
            name = "rabbitmq-config"
          }
        }
      }
    }
    
    update_strategy {
      type = "RollingUpdate"
      rolling_update {
        partition = 1
      }
    }

    volume_claim_template {
      metadata {
        name = "prometheus-data"
      }

      spec {
        access_modes       = ["ReadWriteOnce"]
        storage_class_name = "standard"

        resources {
          requests = {
            storage = "16Gi"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "rabbitmq" {
  metadata {
    name      = "rabbitmq"
    namespace = "rabbitmq-solaborate"
  }

  spec {
    selector = {
      app = "rabbitmq"
    }

   port {
      port        = 5672
      target_port = 5672
    }
  }
}
