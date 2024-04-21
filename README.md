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

### terraform show

Hat man bereits einmal ein Apply durchgeführt, wird dadurch ein Status erzeugt. Den Status des aktuellen Deployments kann man sich via ```terraform show``` anzeigen lassen. Der Befehl zeigt die folgende Ausgabe:

```
henkenbrink@penguin:~/programming/terraformprojects/learningterraform/learn-terraform-docker-container$ terraform show
# docker_container.nginx:
resource "docker_container" "nginx" {
    attach                                      = false
    bridge                                      = null
    command                                     = [
        "nginx",
        "-g",
        "daemon off;",
    ]
    container_read_refresh_timeout_milliseconds = 15000
    cpu_set                                     = null
    cpu_shares                                  = 0
    domainname                                  = null
    entrypoint                                  = [
        "/docker-entrypoint.sh",
    ]
    env                                         = []
    hostname                                    = "b0e6873adef2"
    id                                          = "b0e6873adef2bae5dee105acbc45bfb2d1a663756fbf655545a545724ea9e1e7"
    image                                       = "sha256:2ac752d7aeb1d9281f708e7c51501c41baf90de15ffc9bca7c5d38b8da41b580"
    init                                        = false
    ipc_mode                                    = "private"
    log_driver                                  = "json-file"
    logs                                        = false
    max_retry_count                             = 0
    memory                                      = 0
    memory_swap                                 = 0
    must_run                                    = true
    name                                        = "tutorial"
    network_data                                = [
        {
            gateway                   = "172.17.0.1"
            global_ipv6_address       = null
            global_ipv6_prefix_length = 0
            ip_address                = "172.17.0.2"
            ip_prefix_length          = 16
            ipv6_gateway              = null
            mac_address               = "02:42:ac:11:00:02"
            network_name              = "bridge"
        },
    ]
    network_mode                                = "default"
    pid_mode                                    = null
    privileged                                  = false
    publish_all_ports                           = false
    read_only                                   = false
    remove_volumes                              = true
    restart                                     = "no"
    rm                                          = false
    runtime                                     = "runc"
    security_opts                               = []
    shm_size                                    = 64
    start                                       = true
    stdin_open                                  = false
    stop_signal                                 = "SIGQUIT"
    stop_timeout                                = 0
    tty                                         = false
    user                                        = null
    userns_mode                                 = null
    wait                                        = false
    wait_timeout                                = 60
    working_dir                                 = null

    ports {
        external = 8000
        internal = 80
        ip       = "0.0.0.0"
        protocol = "tcp"
    }
}

# docker_image.nginx:
resource "docker_image" "nginx" {
    id           = "sha256:2ac752d7aeb1d9281f708e7c51501c41baf90de15ffc9bca7c5d38b8da41b580nginx"
    image_id     = "sha256:2ac752d7aeb1d9281f708e7c51501c41baf90de15ffc9bca7c5d38b8da41b580"
    keep_locally = false
    name         = "nginx"
    repo_digest  = "nginx@sha256:0463a96ac74b84a8a1b27f3d1f4ae5d1a70ea823219394e131f5bf3536674419"
}
henkenbrink@penguin:~/programming/terraformprojects/learningterraform/learn-terraform-docker-container$ 
```

**Es wird also der aktuell deployte Stand gezeigt.**

### terraform state list
Terraform kennt einen ```state```-Befehl, mit dem man fortgeschrittene State-Bearbeitung durchführen kann. Eine übersichtliche Auflistung der deployten Ressourcen zeigt der Befehl ```terraform state list``` mit der folgenden Ausgabe:

```
henkenbrink@penguin:$ terraform state list
docker_container.nginx
docker_image.nginx
henkenbrink@penguin:$
```

Kurz und knapp!

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


## Der Terraform State
Wenn man die Konfiguration via ```terraform apply``` deployed hat, schreibt Terraform in eine Datei ```terraform.tfstate```. Darin speichert Terraform die IDs und Properties der Ressourcen, die angelegt wurden und die von Terraform verwaltet werden. Mit diesem State kann Terraform dann die Updates und Destroys auf dieser Konfiguration durchführen.


Die Terraform-State-Datei ist der einzige Ort, über den Terraform weiß, wlche Ressourcen von ihm verwalet werden. Oftmals sind darin geheime Informationen wie Passwörter etc. enthalten. Das ```terraform.tfstate```-File sollte aus diesem Grund sicher gespeichert und der Zugriff eingeschränkt werden. 

Für Produktionsumgebungen wird empfohlen, den State remote zu halten.

Die Datei liegt standardmäßig im selben Ordner wie die Konfiguration selbst. Um sie nicht versehentlich einzuchecken, sind in einer via github erzeugten .gitignore-Datei die beiden folgenden Einträge bereits enthalten:

```
# .tfstate files
*.tfstate
*.tfstate.*
```
So gelangt weder der State selbst, noch sein Backup in dem Repository.

