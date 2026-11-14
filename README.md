# 2. Конфликт при rebase

**Ветки:** `ex02/main`, `ex02/feature`. Обе ветки поменяли одну и ту же строку `greeting` в `config.txt`.

```
* C2: main: change greeting          <- ex02/main      greeting = Hello from main
| * F2: feature: add language        <- ex02/feature
| * F1: feature: change greeting                       greeting = Hello from feature
|/
* C1: init config                                      greeting = Hello
```

## Задание

1. Перебазируй `ex02/feature` на `ex02/main`: получишь конфликт.
2. Во время конфликта сделай `git checkout --ours config.txt` и посмотри, чья версия оказалась в файле.
3. Сделай `git rebase --abort`, повтори rebase и разреши конфликт правильно.

<details>
<summary>Решение</summary>

```bash
git switch ex02/main
git switch ex02/feature
git rebase ex02/main
# CONFLICT (content): Merge conflict in config.txt
# error: could not apply ... F1: feature: change greeting
git status
git checkout --ours config.txt
cat config.txt          # greeting = Hello from main   <- версия MAIN, а не твоей ветки!
```

Почему так: rebase переключается на `ex02/main` и по одному накатывает поверх него твои коммиты. Поэтому роли «наш/их» меняются местами:

|            | merge                      | rebase                                                       |
|------------|----------------------------|--------------------------------------------------------------|
| `--ours`   | твоя текущая ветка         | ветка, **на которую** перебазируешь (main + уже накаченные коммиты) |
| `--theirs` | вливаемая ветка            | **твой** коммит, который применяется сейчас (F1)             |

Маркеры конфликта можно вернуть без abort: `git checkout --merge config.txt`.

```bash
git rebase --abort      # ветка вернулась в состояние до rebase
git status             # чисто, ты снова на ex02/feature
git rebase ex02/main
```

Открой `config.txt`, убери маркеры `<<<<<<<`, `=======`, `>>>>>>>` и оставь одну итоговую строку, например `greeting = Hello from main and feature`.

```bash
git add config.txt
git rebase --continue   # откроется редактор с сообщением F1: сохрани и закрой
git log --graph --oneline ex02/main ex02/feature
```

F2 накатится сам: он меняет другую строку. Итог: `C1 - C2 - F1' - F2'`.

</details>

**Начать заново** (если rebase ещё идёт, сначала `git rebase --abort`):

```bash
git switch ex02/feature
git reset --hard origin/ex02/feature
```
