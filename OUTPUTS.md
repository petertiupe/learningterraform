# Outputvariablen mit Terraform

Um Outputs zu generieren nutzt man Eintäge wie die folgenden
```
output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.nginx.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.nginx.id
}
```

```terraform apply``` sorgt bei diesem Output für folgende Ausgabe:

```
Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

container_id = "29fd5e54837420619f02485e28d3e9f97ca0fcf18c93f2f924c97b76e2ac9228"
image_id = "sha256:2ac752d7aeb1d9281f708e7c51501c41baf90de15ffc9bca7c5d38b8da41b580nginx"
```

Mit dem Befehl ```terraform output``` kann man diese Output-Variablen  abfragen:

```
henkenbrink@penguin:$ terraform output
container_id = "29fd5e54837420619f02485e28d3e9f97ca0fcf18c93f2f924c97b76e2ac9228"
image_id = "sha256:2ac752d7aeb1d9281f708e7c51501c41baf90de15ffc9bca7c5d38b8da41b580nginx"
henkenbrink@penguin:$ 
```

Man kann diesen Output nutzen, um ihn mit anderen Teilen seiner Konfiguration zu verknüpfen oder um 
zwei unterschiedliche Terraformprojekte zu verbinden. 

// TODO: wie man mit den Variablen weiter arbeiten kann, muss noch beschrieben werden.