/*
  Terraform nimmt jede Datei, die im richtigen Ordner liegt und auf *.tf endet
  als Bestandteil der Konfiguration. Diese Datei muss also nicht variables.tf
  heißen, so ist der Name jedoch sprechend.
*/

/* Die Variable heißt Container und kann genau so in der main.tf referenziert werden. */
variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ExampleNginxContainer"
}
