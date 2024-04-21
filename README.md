# Projekt learningterraform
Terraform-Beispiele und Dokumentation. 
Jedes Terraform - Beispielprojekt benötigt einen eigenen Unterordner in dem Projekt. Aus diesem Grunde verweise ich hier auf die Projekte und schreibe in dieser README.md nur allegmeine Hinweise und Allgemeines zu Terraform auf.

[Docker-Container mit Terraform deployen](./learn-terraform-docker-container/README.md)


## Der Terraform Workflow

Bei einem einfachen Beispiel startet der Terraform-Workflow mit einer ```main.tf```-Datei. Diese enthält die Provider und die Konfiguration, wie in dem folgenden Screenshot zu sehen [einfachstes Terraformprojekt](./terraformbasis.png).

### terraform init

Hat man eine "nackte" Terraformkonfiguration, muss man diese mit dem Befehl ```terraform init``` initialisieren.
Dieser Befehl erzeugt ein Konfigurationsverzeichnis und lädt und installiert dorthin die Provider, die in der Konfiguration genannt
werden [init-Befehl](./terraform_init.png). Nach dem Aufruf hat man in der Konfiguration einen Order ```.terraform``` dessen einfachen 
Inhalt der folgende Screenshot zeigt [.terraform-Verzeichnis](./terraform-folder.png)

Der Screenshot von dem Verzeichnis zeigt sehr gut, welche Struktur die Terraform-Registry hat. Ähnlich wie bei NPM oder 
Gradle wird die heruntergeladene Bibliothek in einem Verzeichnis abgelegt, welches die Version etc. enthält:

```.terraform/providers/registry.terraform.io/kreuzwerker/docker/3.0.2/linux_amd64```

worin die folgenden Dateien enthalten sind:

```
CHANGELOG.md
LICENSE
README.md
terraform-provider-docker_v3.0.2
```



