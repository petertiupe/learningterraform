/*
  Als Konfiguration bezeichnet man in Terraform den Satz von Dateien, der die gewünschte Infrastruktur abbildet. Als Klammer
  für eine Konfiguration hat man den Dateiordner, in dem sich die Konfiguration befindet. Umgekehrt heißt das auch, dass
  sich jede Terraformkonfiguration in einem eigenen Order befinden muss.

  Die hier gezeigte Konfiguration startet einen Docker-Container mit nginx und läuft auf dem Port 8000 unter localhost.
  Der Port ist unten in der Datei konfiguriert.
  Aus der Konsole heraus kann man mit curl testen:

  curl http://localhost:8000

*/

/*
  Der terraform {} block beinhaltet die Terraformsettings, die aus dem benötigten Provider besteht. 
  Terraform nutzt diesen Provider um die Infrastruktur zu provisionieren. 
  Das source-Attribut beschreibt, wo der Provider zu finden ist. Es beinhaltet eienen optionalen hostname, 
  einen namespace, und den Providertype. Per Default werden die Provider von der Terraform Registry genutzt. 
  Der hier genutzte Eitrag 'kreuzwerker/docker' ist die Kurzform von registry.terraform.io/kreuzwerker/docker.

  Man sollte bei der Version des Providers immer eine Angabe machen, damit man nicht überrascht wird, wenn 
  es eine neue Version gibt, deren Einstellungen man noch nicht kennt.

  Es ist durchaus möglich, mehrere Provider-Blöcke in einer Konfiguratio. Z. B. könnte der hier erzeugte Dockercontainer
  Bestandteil eines Kubernetes Services werden.
*/
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {}

/*
  Eine Ressource ist ein Bestandteil der Infrastruktur. Hier gibt es das Docker-Image und den Docker-Container als
  Ressourcen.

  Die ersten beiden Stringeinträge bei einer Ressource bestehen aus dem Typ und dem Namen der Ressource. Die Notation
  ist ähnlich wie bei Java (als Eselsbrücke), erst kommt der Typ, dann der Name. 
  
*/
resource "docker_image" "nginx" {
  name         = "nginx"
  keep_locally = false
}

resource "docker_container" "nginx" {
  image = docker_image.nginx.image_id
  name  = var.container_name

  ports {
    internal = 80
    external = 8000
  }
}
