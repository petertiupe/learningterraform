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

### terraform fmt und terraform validate 

Wenn man eine Terraform-Konfiguration erstellt hat, sollte man diese formatieren, sodass alle Nutzer
dasselbe Format sehen und man Unterschiede schnell erkennen kann.

```terraform fmt```

Neben der Formatierung kann man auch noch dafür sorgen, dass die Konfiguration valide ist. Dazu gibt es den
Befehl:

```terraform validate```

Im Erfolgsfall wird die folgende Ausgabe erzeugt:

```´terraform
henkenbrink@penguin:$ terraform validate
Success! The configuration is valid
```

### terraform plan -out &lt;outFilename&gt;

Um zu sehen, was die Terraform-Konfiguration erzeugen / ändern würde, gibt es den Befehl ```terraform plan```. Er erzeugt für ein einfaches Beispiel folgende Ausgabe:

```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # docker_container.nginx will be created
  + resource "docker_container" "nginx" {
      + attach                                      = false
      + bridge                                      = (known after apply)
       ....
      + wait_timeout                                = 60

      + ports {
          + external = 8000
          + internal = 80
          + ip       = "0.0.0.0"
          + protocol = "tcp"
        }
    }

  # docker_image.nginx will be created
  + resource "docker_image" "nginx" {
      + id           = (known after apply)
      + image_id     = (known after apply)
      + keep_locally = false
      + name         = "nginx"
      + repo_digest  = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

Ich habe die Ausgabe für den Container hier stark gekürzt, um nicht den Blick für das Wesentliche zu verlieren. Terraform hilft auch gleich mit einem Hinweis:

```
Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
```

Es ist also immer besser, die Option ```-out <outFilename>``` zu nutzen, wobei ```<outFilename>``` ein beliebiger Dateiname sein darf.

Dann erhält man als Ausgabe:

```
Saved the plan to: outFilename

To perform exactly these actions, run the following command to apply:
    terraform apply "outFilename"
```

### terraform apply "outFilename"

Wenn die Ausgabe des ```plan```-Befehls genau das ist, was man haben möchte, kommt der Befehl, der die Arbeit macht und den entsprechenden Container erzeugt:

```terraform apply "<outFilename>"``` 

```outFilename``` ist hier der Name der Datei, in die man den ```terraform plan -out <outFilename>``` hat schreiben lassen.

Der Befehl erzeugt die folgende Ausgabe:

```
henkenbrink@penguin:$ terraform apply petersConfig
docker_image.nginx: Creating...
docker_image.nginx: Still creating... [10s elapsed]
docker_image.nginx: Creation complete after 11s [id=sha256:2ac752d7aeb1d9281f708e7c51501c41baf90de15ffc9bca7c5d38b8da41b580nginx]
docker_container.nginx: Creating...
docker_container.nginx: Creation complete after 0s [id=6635a0bcf2bf79686513a7de024e1d0aa55ef68b2faafece190da2df3627b091]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
henkenbrink@penguin:$ 
```


### terraform destroy

Um die Anwendung, die vollständig mit Terraform installiert wurde wieder zu deinstallieren, hat man den Befehel
```terraform destroy```, der die folgende Ausgabe erzeugt:

```
Plan: 0 to add, 0 to change, 2 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: 
```

Es wird zunächst noch einmal ausgegeben, welche Ressource(n) betroffen sind und zur Sicherheit wird 
nachgefragt, ob die Ressourcen wirklich gelöscht werden sollen. 

Die Eingabe von ```yes``` in der Konsole führt das Gewünschte dann aus:

```
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

docker_container.nginx: Destroying... [id=6635a0bcf2bf79686513a7de024e1d0aa55ef68b2faafece190da2df3627b091]
docker_container.nginx: Destruction complete after 1s
docker_image.nginx: Destroying... [id=sha256:2ac752d7aeb1d9281f708e7c51501c41baf90de15ffc9bca7c5d38b8da41b580nginx]
docker_image.nginx: Destruction complete after 0s

Destroy complete! Resources: 2 destroyed.
henkenbrink@penguin:$ 
```