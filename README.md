# DevOps Labs

## Структура

```text
devopslabs/
├── lab02-03/                 # Docker Compose, Nginx, worker и cron
├── lab04/                    # Установка Nginx через Ansible
├── lab05-nmap/               # Сканирование порта 80 через Ansible
├── lab07-nginx-role/         # Роль Nginx с виртуальными хостами
│   └── roles/nginx_vhosts/
│       ├── defaults/
│       ├── tasks/
│       ├── handlers/
│       └── templates/
├── .github/workflows/
│   ├── devops_course_pipeline.yml
│   └── lint.yml
├── videos/
│   ├── lab02/01-compose-nginx.webm
│   ├── lab03/01-worker-cron.webm
│   ├── lab04/01-ansible-nginx.webm
│   ├── lab05/01-nmap.webm
│   ├── lab07-1/01-nginx-role.webm
│   └── lab07-2/01-github-actions.webm
├── requirements-ci.txt
└── README.md
```

## Лабораторные 2–3: Docker Compose

Nginx отдаёт HTML-страницу на порту `80`. Контейнер worker получает изображения
покемонов из PokeAPI и обновляет общий HTML-файл при запуске и каждую минуту
через cron.

Запуск из корня репозитория:

```bash
docker compose -p devopslab2_3 -f lab02-03/docker-compose.yml up -d --build
docker compose -p devopslab2_3 -f lab02-03/docker-compose.yml ps
curl http://localhost/
```

## Лабораторная 4 — Nginx через Ansible

Playbook устанавливает Nginx, копирует `index.html` и включает сервис.
Управляющая VM — `10.0.2.5`, целевая — `10.0.2.6`; подключение по SSH
под пользователем `runner` с sudo. Примеры сетевых настроек находятся в `netplan/`.

Запуск на управляющей VM из каталога `lab04/`:

```bash
ansible-playbook -i inventory.ini install_nginx.yml
curl http://10.0.2.6/
```

## П05 — Переменные и Nmap

Playbook устанавливает Nmap на целевой VM и сканирует TCP-порт `80` по адресам
из `targets.txt`. Используются inventory, переменные, `loop`, `register` и `debug`.
По умолчанию проверяется `10.0.2.6:80` — Nginx из П04 на целевой VM.

Запуск на управляющей VM из корня репозитория:

```bash
ansible-playbook -i lab05-nmap/inventory.ini lab05-nmap/playbook.yml
```

## П07-1 — Роль Nginx

Роль разворачивает сайты `mehmat.ru`, `fizfak.ru` и `etis.com` на порту `8080`.
Список задаётся переменной `sites`; страницы и конфигурации создаются через
Jinja2-шаблоны в цикле. Изменение конфигурации вызывает reload через handler.
Сайты проверяются через curl с заголовком `Host`; повторный запуск
без изменений даёт `changed=0`.

Запуск на управляющей VM из корня репозитория:

```bash
ansible-playbook -i lab07-nginx-role/inventory.ini lab07-nginx-role/playbook.yml
curl -H 'Host: mehmat.ru' http://10.0.2.6:8080/
```

## П07-2 — GitHub Actions

- `devops_course_pipeline.yml` — при каждом push выполняет `echo`, `uptime`,
  `pwd` и `whoami` на Ubuntu runner.
- `lint.yml` — при push в `main` и Pull Request проверяет новые playbook и роль
  через `ansible-lint` и `ansible-playbook --syntax-check`.

Версии Ansible и ansible-lint для CI указаны в `requirements-ci.txt`.
