/*
  Mit outputs werden Variablen definiert, die nach einem Apply weiterverarbeitet werden können.
*/

output "container_id" {
  description = "ID of the Docker container"
  value       = docker_container.nginx.id
}

output "image_id" {
  description = "ID of the Docker image"
  value       = docker_image.nginx.id
}
