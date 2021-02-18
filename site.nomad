job "christopherjones-us" {
  datacenters = ["dc1"]

  type = "service"

  reschedule {
    delay = "30s"
    delay_function = "constant"
    unlimited = true
  }

  update {
    max_parallel      = 1
    health_check      = "checks"
    min_healthy_time  = "10s"
    healthy_deadline  = "5m"
    progress_deadline = "10m"
    auto_revert       = true
    canary            = 0
    stagger           = "30s"
  }

  group "servers" {
    count = 1

    restart {
      interval = "10m"
      attempts = 2
      delay    = "15s"
      mode     = "fail"
    }

    task "writefreely" {
      driver = "docker"
      config {
        image = "docker.pkg.github.com/magikid/christopherjones.us/christopherjonesus:latest"
        port_map = {
          http = 5000
        }
      }

      template {
        data = <<EOH
DB_USERNAME="{{key "writefreely/database/username"}}"
DB_PASSWORD="{{key "writefreely/database/password"}}"
DB_NAME="{{key "writefreely/database/database"}}"
DB_HOST="{{key "writefreely/database/host"}}"
DB_PORT="{{key "writefreely/database/port"}}"
EOH
        destination = "secrets/file.env"
        env         = true
      }

      env {
        PORT = "${NOMAD_PORT_http}"
      }

      service {
        name = "christopherjones-us"
        port = "http"
        tags = ["urlprefix-/christopherjones-us"]
        check {
          name     = "christopherjones-us health using http endpoint '/'"
          port     = "http"
          type     = "http"
          path     = "/"
          method   = "GET"
          interval = "10s"
          timeout  = "2s"
        }

        check_restart {
          limit = 3
          grace = "10s"
          ignore_warnings = false
        }
      }

      resources {
        cpu    = 100 # MHz
        memory = 256 # MB
        network {
          mbits = 10
          port "http" {}
        }
      }
    }
  }
}
