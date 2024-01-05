# [Odoo](https://www.odoo.com "Odoo's Homepage") Install Script

Este script é baseado no script de instalação de André Schenkels (https://github.com/aschenkels-ictstudio/openerp-install-scripts), mas vai um pouco mais longe e foi aprimorado. Este script também lhe dará a capacidade de definir uma porta xmlrpc_port no arquivo .conf que é gerado em /etc/. Este script pode ser usado com segurança em um servidor de base de código multi-Odoo porque a porta padrão do Odoo é alterada ANTES que o Odoo seja iniciado.

## Instalação do Nginx
Se você definir o parâmetro ```INSTALL_NGINX``` como ```True```, você também deve configurar os workers. Sem os workers, é provável que você tenha problemas de perda de conexão. Consulte o guia [the deployment guide from Odoo](https://www.odoo.com/documentation/16.0/administration/install/deploy.html) de implantação do Odoo sobre como configurar os workers.

## Processos de Instalação

### 1. Baixe a pasta do script:

Já dentro da sua VM/Cloud/Terminal, copie e de enter:
```
git clone https://github.com/guilbezerra/InstallScriptCIEL.git
```

### 2. Permissão de execução:

Entre na pasta que acabamos de clonar com:
```
cd InstallScriptCIEL/
```

Comece dando a permissão de execução para o script principal e mais um que posteriormente podemos vir a usar:
```
sudo chmod +x odoo_install.sh
```
```
sudo chmod +x create_role.sh
```
### 3. Modifique os parâmetros:
Usando
```
sudo nano odoo_install.sh
```
  Existem algumas configurações que podemos mudar, segue a lista: :<br/>
```OE_USER```. Será o nome de usuário para o usuário do sistema. Seguiremos com o padrão: ODOO<br/>
```GENERATE_RANDOM_PASSWORD```. Se isso estiver definido como True, o script gerará uma senha aleatória; se definido como False, a senha será configurada em ```OE_SUPERADMIN.``` O valor padrão é True, e o script gerará uma senha aleatória e segura.<br/>
```OE_SUPERADMIN``` É a senha principal para esta instalação do Odoo. Caso queira modificar a senha. `Certifique-se de usar letras maiúsculas e minúsculas, números e caracteres especiais, ou ele continuará gerando uma senha aleatória por ser mais "segura"`. Essa senha pode ser alterada dentro do próprio odoo quando conseguirmos criar nossa primeira database.<br/>
```INSTALL_WKHTMLTOPDF``` Definido como False se você não quiser instalar o [Wkhmtltopdf](https://wkhtmltopdf.org/usage/wkhtmltopdf.txt); definido como True se desejar instalá-lo. Essa é uma ferramentas de linha de comando para renderizar HTML em PDF e vários formatos de imagem usando o Qt WebKit 
```OE_PORT``` É a porta em que o Odoo deve ser executado, por exemplo, 8069.<br/>
```OE_VERSION``` É a versão do Odoo a ser instalada, por exemplo, 16.0 para Odoo V16.<br/>
```IS_ENTERPRISE``` Instalará a versão Enterprise sobre 16.0 se definido como True, ou a versão da comunidade do Odoo 16 se definido como False.<br/>
```INSTALL_NGINX``` é definido como False por padrão. Defina como True se desejar instalar o Nginx.<br/>
```WEBSITE_NAME```Defina o nome do site aqui para a configuração do Nginx.<br/>
```ENABLE_SSL``` Defina como True para instalar [certbot](https://github.com/certbot/certbot) e configurar o Nginx com https usando um certificado gratuito do Let's Encrypt.<br/>
```ADMIN_EMAIL``` O e-mail é necessário para o registro do Let's Encrypt. Substitua o espaço reservado padrão por um e-mail da sua organização.<br/>
```INSTALL_NGINX``` e ´´´ENABLE_SSL´´´ devem ser definidos como True e o espaço reservado em ´´´ADMIN_EMAIL´´´ deve ser substituído por um endereço de e-mail válido para a instalação do certbot.<br/>
  _Ao ativar o SSL por meio do Let's Encrypt, você concorda com as seguintes políticas <br/>

### 4. Execute o script:
```
sudo ./odoo_install.sh
```
Aguarde até o final, pressionando ENTER e digitando "Y" sempre que o script for pedindo. ao finalizar,
você deve receber uma mensagem no terminal assim:


Done! The Odoo server is up and running. Specifications:<br/>
Port: ```OE_PORT```.<br/>
User service: ```OE_USER```.<br/>
Configuraton file location: /etc/```OE_USER```.conf<br/>
Logfile location: /var/log/odoo<br/>
User PostgreSQL: ```OE_USER```.<br/>
Code location: ```OE_USER```.<br/>
Addons folder: ```OE_USER```/```OE_USER```-server/addons/<br/>
Password superadmin (database): "Sua senha colocada nos parâmetros" / Uma senha aleatória, exemplo: J4EzGDdGYvq8Eddz<br/>
Start Odoo service: sudo service ```OE_USER```-server start<br/>
Stop Odoo service: sudo service ```OE_USER```server stop<br/>
Restart Odoo service: sudo service ```OE_USER```-server restart<br/>

### 5. Inicie os serviços:

Como está instalação foi criada em WSL usando o Ubuntu disponivel na Microsoft Store, para iniciar os serviços ```OE_USER```-server``` e ```postgresql```, digite:
##### (o nome ```OE_USER``` será igual o que você colocou no parâmetro do passo #3, na qual o padrão que estamos seguindo é "odoo")
```
sudo service odoo-server start
```

```
sudo service postgresql start
```
Entretanto, caso esteja fazendo esse processo em uma máquina linux, o comando pode alterar para systemctl, sendo assim:
```
sudo systemctl odoo-server start
```
```
sudo systemctl postgresql start
```

Iniciando o serviços, seu odoo já estará rodando local/cloud e pode ser acessado por localhost:8069 ou "Seu ip do cloud":8069 (possivelmente o Cloud pode ter problemas com a porta, precisando ser liberada nas configurações do serviço de nuvem)

### 6. Troubleshoot:

Ao finalizar a instalação, podemos nós deparar com alguns problemas.

Para podermos modificar alguns desse arquivos, primeiro precissamos estar no root, com o seguinte comando:
```
sudo -i
```

#### 1 - Database creation error: Access Denied
  Se  você está recebendo essa mensagem, a senha do ```OE_SUPERADMIN``` não foi definida, precisando ser alterada seguindo o seguinte caminho:
  ```
  cd /etc/
```
  E alterando o seguinte arquivo:
  
```
nano odoo-server.conf
```
  Mudando a linha ```admin_passwd =``` e apertando CTRL+X para sair do arquivo, "Y" para confirmar a mudança que fizemos na senha e "Enter" para fechar. 
  Reinicie o serviço odoo e sua nova senha deve estar funcionando. 
```
sudo service odoo-server restart
```
Caso esteja usando systemctl:
```
sudo systemctl odoo-server restart
```

##### LEMBRANDO: certifique-se de usar letras maiúsculas e minúsculas, números e caracteres especiais, ou ele continuará gerando uma senha aleatória por ser mais "segura"
  

 #### 2 - Database creation error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: No such file or directory Is the server running locally and accepting connections on that socket?

Este erro pode ser o PostgreSQL não ter sido executado, para isso: 
##### 2.1 - PostgreSQL não estar executado, certifique-se de ter digitado:
```
sudo service postgresql start
```
Caso esteja usando systemctl:
```
sudo systemctl postgresql start
```
Caso o erro continue, rode os próximos dois comandos:
##### 2.2 - PostgreSQL está ouvindo na porta errada:
Para resolver isso, rode o comando:
```
sudo sed -i 's/port = 5433/port = 5432/' /etc/postgresql/14/main/postgresql.conf
```
##### 2.3 - PostgreSQL está com as configurações de autentificação errada:
Para corrigir, rode os comandos:
```
sudo sed -i 's/local   all             postgres                                peer/local   all             all                                     trust/' /etc/postgresql/14/main/pg_hba.conf
```


```
sudo sed -i 's/local   all             all                                peer/local   all             all                                trust/' /etc/postgresql/14/main/pg_hba.conf
```


Apos esses comandos, rode novamente:
```
sudo service postgresql restart
```

 #### 3 - Database creation error: connection to server on socket "/var/run/postgresql/.s.PGSQL.5432" failed: FATAL: role "odoo" does not exist

Este erro ocorre quando o script não cria uma Role no PostgreSQL necessária para o Odoo funcionar, para isso, devemos executar o script ./create_role.sh que tornamos executável no passo #2. Para corrigir, vá até a pasta inicial com:
 ```
cd /home/"Seu usuario"/InstallScriptCIEL/
```
execute o script com:

 ```
sudo ./create_role.sh
```
Se o arquivo for executado corretamente, ele deve exibir a mensagem:

"Insira a linha "User service" para criar a role do PostgreSQL:"

"Precisamos, assim, digitar o mesmo valor que estiver no 'User service' da mensagem de sucesso no passo #4, o que significa que o valor será o mesmo do ```OE_USER``` citado no passo #3 dos parâmetros. Dando 'enter', ele retorna a mensagem:"

"CREATE ROLE"

Tendo assim criado a role com sucesso, podemos dar restart em ambos os serviços.

```
sudo service OE_USER-server restart
sudo service postgresql restart
```
Caso esteja usando systemctl:
```
udo systemctl OE_USER-server restart
sudo systemctl postgresql restart
```

### 6. Criando a primeira database:

Quando conseguirmos entrar na tela de criar nossa primeira database, veremos os seguintes campos:

![image](https://github.com/guilbezerra/InstallScriptCIEL/assets/146212857/61cb968d-30a3-488a-9267-734492fa03e6)

```Master Password```: É a mesma senha de admin que colocamos em ```OE_SUPERADMIN``` e servirá para criar a database <br/>
```Database Name```: O nome que nossa database terá<br/>
```Email```: Mesmo com esse nome, não precisa ser um, esse será nosso usuário de login. Podendo ser por exemplo: Admin <br/>
```Password```: A senha que usaremos para logar na conta<br/>
```Phone Number```: Número de telefone (opcional)<br/>
```Language``` A linguagem do seu Odoo<br/>
```Country```Seleção de país<br/>
```Demo data```: Popula a base com dados de demonstração <br/>

## Onde devo hospedar o Odoo?
Existem muitos excelentes serviços que oferecem boas opções de hospedagem. O script foi testado com alguns dos principais provedores, como [Google Cloud](https://cloud.google.com/), [Hetzner](https://www.hetzner.com/), [Amazon AWS](https://aws.amazon.com/) and [DigitalOcean](https://www.digitalocean.com/products/droplets/).
Se desejar, você pode usar o meu link de indicação do DigitalOcean, que lhe oferece um voucher de 200 dólares gratuitos para os primeiros 60 dias.

## Requisitos mínimos do servidor
Embora tecnicamente seja possível executar uma instância do Odoo com 1GB (1024MB) de RAM, isso não é absolutamente aconselhável. Uma instância Linux normalmente usa de 300MB a 500MB, e o restante deve ser dividido entre o Odoo, o PostgreSQL e outros componentes. Se você estiver instalando o Odoo, deve garantir o uso de pelo menos 2GB de RAM. Este script pode falhar com menos recursos.
Há problemas conhecidos no DigitalOcean, por exemplo, onde a instalação falha em máquinas com 1GB de RAM. Consulte https://github.com/Yenthe666/InstallScript/issues/243.
