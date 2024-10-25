Ce projet consiste à déployer une infrastructure web simple sur AWS à l'aide de Terraform.
L'infrastructure comprend une VPC (Virtual Private Cloud) avec un sous-réseau public, une passerelle Internet pour permettre l'accès externe,
une table de routage pour gérer les connexions, et une instance EC2 sur laquelle Nginx est installé pour servir des pages web. 
Le projet utilise également un groupe de sécurité pour ouvrir les ports 80 (HTTP) et 22 (SSH) afin de permettre le trafic web et l'accès à distance sécurisé.
Terraform gère l'initialisation, la création et l'application de la configuration, tandis qu'une clé SSH permet de se connecter à l'instance EC2 une fois le déploiement terminé. 
Nginx est automatiquement installé sur l'instance via un script de configuration (user_data),
et l'IP publique de l'instance est renvoyée pour permettre l'accès direct au serveur Nginx via un navigateur.
