# Git-песочница: 10 упражнений

Каждое упражнение живёт в своих ветках `exNN/...`. Все ветки «осиротевшие» (orphan): у них нет общей истории ни с `main`, ни друг с другом, внутри только пара текстовых файлов. Поэтому графы маленькие и читаемые, а `main` с Laravel-проектом не тронут.

В каждой ветке лежит `README.md`: задание, стартовый граф и спрятанное решение (раскрывается по клику на «Решение»).

## ⚠️ Работай в отдельном клоне

Не делай упражнения в рабочей папке Laravel-проекта. Там незакоммиченные правки и настоящий `.env`: `reset --hard` сотрёт правки, а `git switch ex10/gitignore` молча перезапишет игнорируемый `.env`, потому что git считает игнорируемые файлы расходными.

```bash
git clone https://github.com/kakashaUbivasha/testik.git D:/git-sandbox
cd D:/git-sandbox
```

## Как начать упражнение

```bash
git switch ex01/main
```

Локальной ветки ещё нет, но есть `origin/ex01/main`, поэтому `git switch` сам создаст локальную ветку, отслеживающую удалённую.

Сломал — начни заново: верни локальную ветку к состоянию с GitHub.

```bash
git switch ex01/main
git reset --hard origin/ex01/main
```

Смотреть граф удобнее по конкретным веткам:

```bash
git log --graph --oneline ex01/main ex01/feature
```

## Упражнения

| # | Тема | Ветки |
|---|------|-------|
| 1 | merge vs rebase | `ex01/main`, `ex01/feature` |
| 2 | Конфликт при rebase, чей `--ours` | `ex02/main`, `ex02/feature` |
| 3 | reflog после `reset --hard HEAD~3` | `ex03/reflog` |
| 4 | Вернуть ветку после `branch -D` | `ex04/main`, `ex04/feature` |
| 5 | Потерянный индекс, `fsck --lost-found` | `ex05/lost-index` |
| 6 | Чистка истории через `rebase -i` | `ex06/wip` |
| 7 | Revert merge и revert реверта | `ex07/main`, `ex07/feature` |
| 8 | `--force-with-lease` и `--force-if-includes` | `ex08/start` (засев для bare-репо) |
| 9 | `bisect run` | `ex09/bisect` |
| 10 | Перестать отслеживать `.env` | `ex10/gitignore` |

## Особенности Windows

- **PowerShell и `@{...}`.** Ссылки вида `HEAD@{1}` в PowerShell бери в одинарные кавычки: `git reset --hard 'HEAD@{1}'`. Без кавычек PowerShell считает `@{}` хеш-таблицей. В Git Bash кавычки тоже работают.
- **`&&` в PowerShell 5.1 нет.** Команды в решениях написаны по одной на строку.
- **Редактор.** `core.editor` не настроен, поэтому `rebase -i`, `commit` и `merge` откроют vim (выход с сохранением: `Esc`, затем `:wq`). Чтобы открывался VS Code: `git config --global core.editor "code --wait"`.
- **Перенаправление `>` в PowerShell 5.1** пишет файл не в той кодировке, которую ждёт git. Файлы правь редактором, а для копирования используй `cp`.

## Уборка

Удалить все локальные ветки упражнений (ветки на GitHub останутся):

```bash
git switch main
git branch --list "ex*" --format="%(refname:short)" | ForEach-Object { git branch -D $_ }
```

В Git Bash вместо последней строки: `git branch --list 'ex*' --format='%(refname:short)' | xargs git branch -D`.
