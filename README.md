# 4. Удалённая ветка

**Ветки:** `ex04/main` (C1–C3), `ex04/feature` (F1–F2, не влиты в main).

```
* C3: main: more work         <- ex04/main
| * F2: experiment part 2     <- ex04/feature
| * F1: experiment part 1
|/
* C2: main work
* C1: init
```

## Задание

Удали `ex04/feature` через `git branch -D` (коммиты не слиты) и верни ветку.

<details>
<summary>Решение</summary>

Создаём локальную ветку **без** upstream. Если ветка следит за `origin/ex04/feature`, то `git branch -d` проверяет слитость с upstream, а не с HEAD, и молча удалит её с предупреждением.

```bash
git switch --no-track -c ex04/feature origin/ex04/feature
git switch ex04/main
git branch -d ex04/feature   # error: the branch 'ex04/feature' is not fully merged
git branch -D ex04/feature   # Deleted branch ex04/feature (was 1a2b3c4).
```

Честный режим: убери remote-tracking ссылку, иначе ветку можно просто взять из `origin`.

```bash
git branch -dr origin/ex04/feature
```

Восстановление:

```bash
git reflog -3
# ... HEAD@{0}: checkout: moving from ex04/feature to ex04/main
# ... HEAD@{1}: checkout: moving from ... to ex04/feature        <- HEAD стоял на F2
git branch ex04/feature 'HEAD@{1}'    # или хэш из строки "(was 1a2b3c4)"
git log --oneline ex04/main ex04/feature --graph
```

Журнал самой ветки удаляется вместе с ней, поэтому ищем в журнале HEAD. Если на ветку ни разу не переключались, в reflog HEAD её нет. Тогда поможет `git fsck --lost-found`: он покажет `dangling commit <хэш>`, это F2.

`git fetch` вернёт `origin/ex04/feature` обратно.

</details>

**Начать заново:**

```bash
git fetch
git switch ex04/main
git branch -D ex04/feature
```
