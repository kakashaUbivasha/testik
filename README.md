# 6. Чистка истории

**Ветка:** `ex06/wip`

```
* wip       5: подключает styles.css в <head> index.html
* wip       4: стили кнопки в styles.css
* wip       3: исправляет опечатку «Pasword» в форме
* wip       2: создаёт styles.css со стилями формы
* wip       1: добавляет форму логина в index.html
* init: page skeleton
```

Что внутри каждого wip: `git log -p --reverse HEAD~5..`

## Задание

Через `git rebase -i` превратить 5 коммитов «wip» в 2 осмысленных, используя `squash`, `fixup` и `reword`:

1. `Add login form`: wip 1 и исправление опечатки из wip 3.
2. `Style login form`: wip 2, wip 4 и wip 5.

<details>
<summary>Решение</summary>

```bash
git switch ex06/wip
git rebase -i HEAD~5
```

В редакторе коммиты идут сверху вниз, от старых к новым:

```
pick 1111111 wip    # 1 форма
pick 2222222 wip    # 2 styles.css
pick 3333333 wip    # 3 опечатка
pick 4444444 wip    # 4 кнопка
pick 5555555 wip    # 5 <link>
```

Перенеси строку wip 3 под wip 1 и поменяй команды:

```
reword 1111111 wip
fixup  3333333 wip
pick   2222222 wip
squash 4444444 wip
fixup  5555555 wip
```

- `reword`: взять коммит как есть, но отредактировать сообщение. Откроется редактор, пиши `Add login form`.
- `fixup`: влить в предыдущий коммит и **выбросить** своё сообщение.
- `squash`: влить в предыдущий и **объединить** сообщения. В конце цепочки откроется редактор: удали все «wip», напиши `Style login form`.

Переставлять wip 3 безопасно: он трогает только index.html, а wip 2 только styles.css.

```bash
git log --oneline                  # Style login form / Add login form / init
git diff origin/ex06/wip HEAD      # пусто: файлы те же, поменялась только история
```

</details>

**Начать заново** (если rebase ещё идёт, сначала `git rebase --abort`):

```bash
git reset --hard origin/ex06/wip
```
