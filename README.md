# 9. bisect run

**Ветка:** `ex09/bisect`: 50 коммитов `commit 1` … `commit 50`.

- `calc.sh`: мини-калькулятор (`sh calc.sh add 2 3`).
- `test.sh`: проверка. Код возврата 0, если `2 + 3 = 5`, иначе 1.

На `commit 1` тест проходит, на `commit 50` падает. Где-то посередине сломали сложение. Половина коммитов тоже трогает `calc.sh`, так что `git log calc.sh` не сразу выдаст виновника.

## Задание

Найди сломавший коммит автоматически через `git bisect run`. Ожидаемый ответ: `commit 37`.

<details>
<summary>Решение</summary>

```bash
git switch ex09/bisect
git bisect start HEAD $(git rev-list --max-parents=0 HEAD)
git bisect run sh test.sh
# ...
# 1a2b3c4... is the first bad commit
# ...
#     commit 37
git show refs/bisect/bad       # виновник и его diff
git bisect reset               # вернуться на ветку
```

- `git bisect start <плохой> <хороший>`: плохой — HEAD, хороший — корневой коммит. `git rev-list --max-parents=0 HEAD` выдаёт хэш первого коммита.
- `git bisect run <команда>` на каждом шаге делает checkout середины диапазона и запускает команду. Код 0 значит «хороший», 1–127 (кроме 125) «плохой», 125 «пропустить коммит».
- На 50 коммитах хватает около 6 шагов (log₂ 50).
- После `run` HEAD стоит на последнем проверенном коммите, а не обязательно на виновнике. Найденный коммит лежит в `refs/bisect/bad`, пока не сделан `git bisect reset`.

Скрипт запускается через `sh`, а не `./test.sh`: на Windows у файлов нет бита исполнения. `git bisect run` сам находит `sh` из Git for Windows, даже если в PowerShell команды `sh` нет. Запустить тест вручную в PowerShell можно так: `& "C:\Program Files\Git\bin\sh.exe" test.sh`.

</details>

**Начать заново:**

```bash
git bisect reset
```
