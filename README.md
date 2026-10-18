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
│   └── scripts/new-vm-setup.sh
└── README.md
```

## Лабораторные 2–3: Docker Compose

Nginx отдаёт страницу на порту `80`. Контейнер worker получает изображения
покемонов из PokeAPI и обновляет HTML при запуске и каждую минуту через cron.

Запуск из корня репозитория:

```bash
docker compose -p devopslab2_3 -f lab02-03/docker-compose.yml up -d --build
docker compose -p devopslab2_3 -f lab02-03/docker-compose.yml ps
curl http://localhost/
```

## Лабораторная 4: Nginx через Ansible

Playbook устанавливает Nginx, копирует `index.html` и включает сервис.
Управляющая VM — `10.0.2.5`, целевая — `10.0.2.6`; подключение по SSH
под пользователем `runner` с sudo. Сетевые настройки находятся в `lab04/netplan/`.

Запуск на управляющей VM из каталога `lab04/`:

```bash
ansible-playbook -i inventory.ini install_nginx.yml
curl http://10.0.2.6/
```
