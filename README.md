# 10. .gitignore

**Ветка:** `ex10/gitignore`. Первый шаг («закоммить `.env`») уже сделан в C2, значения фейковые.

```
* C2: add .env (oops)    <- ex10/gitignore
* C1: init app
```

## Задание

Добавь `.env` в `.gitignore` и добейся, чтобы git перестал его отслеживать, а файл остался на диске.

<details>
<summary>Решение</summary>

```bash
git switch ex10/gitignore
# создай .gitignore со строкой .env
git add .gitignore
git commit -m "Ignore .env"
# поменяй что-нибудь в .env
git status                 # modified: .env  <- .gitignore не помог!
```

`.gitignore` действует только на **неотслеживаемые** файлы. Файл, который уже в индексе, git продолжает отслеживать.

```bash
git rm --cached .env       # убрать из индекса, файл на диске не трогать
git commit -m "Stop tracking .env"
git status                 # чисто
ls .env                    # файл на месте
git check-ignore -v .env   # .gitignore:1:.env    .env
```

Что важно помнить:

- `.env` остался в истории: `git show HEAD~2:.env`. Если там были настоящие секреты, их нужно сменить. Вычистить историю можно через `git filter-repo`.
- У коллег при `git pull` этого коммита `.env` **удалится** с диска: для git это удаление файла. Пусть заранее сохранят копию.
- `git update-index --skip-worktree` и `--assume-unchanged` не замена: файл продолжит отслеживаться.

Хочешь пройти и первый шаг сам: `git reset --hard HEAD~1` (удалит `.env` с диска), создай `.env` заново, `git add .env`, `git commit`.

</details>

**Начать заново:**

```bash
git reset --hard origin/ex10/gitignore
```
