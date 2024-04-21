# Terraformvariablen

Variablen in Terraform werden wie folgt definiert:

```
variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "ExampleNginxContainer"
}
```

Die so angelegte Variable hat also auch wieder vor den geschweiften Klammern Typ und dann den Namen.
Der Name vor der geschweiften Klammer gilt nur innerhalb der via Terraform angesprochenen Ressourcen 
Der Name in der geschweiften Klammer ist der Name unter dem die Ressource im Cluster oder hier als
Name mit dem der Dockercontainer angesprochen wird.

An der verwendenden Stelle wird der Name folgendermaßen referenziert:

```
resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  
  // die Variable wird mit var.name, also mit dem Namen, mit dem sie in Terraform bekannt ist, angesprochen
  name  = var.container_name 
  // ***********************
  ports {
    internal = 80
    external = 8000
  }
}

```

Man muss also immer zwischen dem Namen einer Ressource 
entscheiden, den sie im Cluster trägt und dem Namen einer 
Ressource, wie sie innerhalb von Terraform angesprochen wird.

Führt man mit der hier gezeigten Konfiguration ein 
```terraform plan``` durch, ist die folgende Zeile die entscheidende:

```~ name        = "tutorial" -> "ExampleNginxContainer" # forces replacement```

Man sieht, dass der Default-Wert aus der Variablendefinition gezogen wird. Möchte man diesen für das
Deployment ändern, hat man folgende Möglichkeiten:

+ In der Kommandozeile via 

  ```terraform apply -var "container_name=YetAnotherName"```

  Diese Form der Eingabe wird bei mehreren Variablen natürlich fast unmöglich, daher gibt es weitere

+ TODO: hier fehlen die weiteren Möglichkeiten ...


