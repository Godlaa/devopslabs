# DevOps Labs

Лабораторные работы 2–4 в одном репозитории.

```text
devopslabs/
├── lab02-03/
│   ├── docker-compose.yml
│   ├── html/index.html
│   └── worker/
│       ├── Dockerfile
│       ├── cron
│       └── pokemon.sh
├── lab04/
│   ├── ansible.cfg
│   ├── index.html
│   ├── install_nginx.yml
│   ├── inventory.ini
│   ├── netplan/
│   │   ├── vm1-control.yaml
│   │   └── vm2-target.yaml
│   └── scripts/new-vm-setup.sh
├── .gitignore
└── README.md
```

## Лабораторные 2–3: Docker Compose

Nginx отдаёт страницу из `html/`. Контейнер `worker` получает изображения
покемонов из PokeAPI и обновляет страницу при запуске и каждую минуту через cron.

Требуются Docker с Compose v2, запущенный Docker Engine, доступ к интернету
для загрузки образов, пакетов и обращения к PokeAPI, а также свободный порт 80.
Команды выполняются из корня репозитория:

```bash
docker compose -p devopslab2_3 -f lab02-03/docker-compose.yml config --quiet
docker compose -p devopslab2_3 -f lab02-03/docker-compose.yml up -d --build
docker compose -p devopslab2_3 -f lab02-03/docker-compose.yml ps
curl http://localhost/
```

Имя проекта `devopslab2_3` сохраняет прежнюю идентичность Compose после переноса.
Пути `./html` и `./worker` разрешаются относительно файла Compose в `lab02-03/`.
Страница доступна по адресу <http://localhost/>. Генерируемый `html/index.html`
сохранён в Git как исходный пример; работающий worker изменяет этот файл.

Логи и остановка:

```bash
docker compose -p devopslab2_3 -f lab02-03/docker-compose.yml logs -f
docker compose -p devopslab2_3 -f lab02-03/docker-compose.yml down
```

## Лабораторная 4: настройка Nginx через Ansible

Существующий playbook `install_nginx.yml` устанавливает Nginx на целевой ВМ,
копирует `index.html` и включает веб-сервер. В `netplan/` сохранены примеры
настроек сети: управляющая ВМ `10.0.2.5`, целевая ВМ `10.0.2.6`.
Перед использованием примеров проверьте адреса, шлюз и имя сетевого интерфейса.

На управляющей ВМ нужны Ansible и SSH-ключ `~/.ssh/id_rsa`; на целевой —
Debian/Ubuntu с apt, systemd, Python 3 и SSH. Пользователь `runner` должен
иметь доступ по ключу и sudo без пароля. Существующий скрипт подготовки
пользователя запускается **на целевой ВМ**, из корня её копии репозитория:

```bash
sudo bash lab04/scripts/new-vm-setup.sh
```

После этого настройте доступ по SSH с управляющей ВМ, например через
`ssh-copy-id -i ~/.ssh/id_rsa.pub runner@10.0.2.6` при наличии исходного
SSH-доступа. Упомянутого в выводе скрипта `copy-ssh-key.sh` в исходных файлах нет.

На управляющей ВМ, из корня репозитория, создайте локальный inventory:

```bash
cp lab04/inventory.ini lab04/inventory.local.ini
```

Укажите в `lab04/inventory.local.ini` свой адрес ВМ, пользователя и путь к ключу.
Локальный inventory исключён из Git. Запускайте Ansible из `lab04/`, чтобы
подхватить существующий `ansible.cfg` и относительные пути:

```bash
cd lab04
ansible-inventory -i inventory.local.ini --graph
ansible-playbook -i inventory.local.ini install_nginx.yml --syntax-check
ansible-playbook -i inventory.local.ini install_nginx.yml
curl http://10.0.2.6/
```

В последней команде используйте адрес своей целевой ВМ. Проверка синтаксиса
не подтверждает доступность ВМ; применение playbook требует SSH-доступа.
