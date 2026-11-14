# 3. reflog

**Ветка:** `ex03/reflog`: шесть коммитов, C1 … C6.

## Задание

Сделай `git reset --hard HEAD~3` и восстанови все три коммита (C4, C5, C6).

<details>
<summary>Решение</summary>

```bash
git switch ex03/reflog
git log --oneline              # C6 C5 C4 C3 C2 C1
git reset --hard HEAD~3
git log --oneline              # C3 C2 C1: три коммита «пропали»
git reflog -3
# a1b2c3d HEAD@{0}: reset: moving to HEAD~3
# f6e5d4c HEAD@{1}: checkout: moving from main to ex03/reflog   <- тут HEAD был на C6
git reset --hard 'HEAD@{1}'    # или хэш C6, или ORIG_HEAD
git log --oneline              # снова C6 … C1
```

`reset` только передвинул указатель ветки, сами коммиты остались в базе объектов. Пока на них ссылается reflog, `git gc` их не удалит: по умолчанию 90 дней, а для записей, недостижимых из веток, 30 дней.

Кроме журнала HEAD у каждой ветки свой журнал: `git reflog ex03/reflog`, ссылки вида `ex03/reflog@{1}`.

В PowerShell `HEAD@{1}` обязательно в кавычках, иначе `@{}` разберётся как хеш-таблица.

</details>

**Начать заново:**

```bash
git reset --hard origin/ex03/reflog
```
