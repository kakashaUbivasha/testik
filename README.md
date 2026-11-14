# 1. merge vs rebase

**Ветки:** `ex01/main` (M1–M4), `ex01/feature` (F1–F2).

```
* M4: hotfix in main        <- ex01/main
| * F2: improve search      <- ex01/feature
| * F1: add search module
|/
* M3: add footer
* M2: add menu
* M1: init project
```

Конфликтов не будет: main меняет `app.txt`, feature меняет `search.txt`.

## Задание

1. Слей `ex01/feature` в `ex01/main` через merge и зарисуй граф.
2. Откати merge через `git reset --hard ORIG_HEAD`.
3. Повтори через rebase + fast-forward.
4. Сравни хэши коммитов feature до и после.

<details>
<summary>Решение</summary>

```bash
git switch ex01/feature
git switch ex01/main
git log --oneline -2 ex01/feature      # запиши хэши F2 и F1
```

**1. merge**

```bash
git merge ex01/feature -m "Merge ex01/feature"
git log --graph --oneline ex01/main
```

```
*   Merge ex01/feature
|\
| * F2: improve search
| * F1: add search module
* | M4: hotfix in main
|/
* M3: add footer
* M2: add menu
* M1: init project
```

Появился merge-коммит с двумя родителями (M4 и F2). Хэши F1 и F2 не изменились.

**2. Откат.** `ORIG_HEAD` хранит, где стоял HEAD до «опасной» операции (merge, rebase, reset). Здесь это M4.

```bash
git reset --hard ORIG_HEAD
git log --oneline -1                   # M4
```

**3. rebase + fast-forward**

```bash
git switch ex01/feature
git rebase ex01/main
git switch ex01/main
git merge --ff-only ex01/feature
git log --graph --oneline ex01/main
```

```
* F2: improve search
* F1: add search module
* M4: hotfix in main
* M3: add footer
* M2: add menu
* M1: init project
```

**4. Хэши**

```bash
git log --oneline -2 origin/ex01/feature   # до rebase
git log --oneline -2 ex01/feature          # после rebase: хэши другие
git range-diff origin/ex01/main origin/ex01/feature ex01/feature
```

Хэш коммита считается от дерева файлов, автора, даты, сообщения **и хэша родителя**. У F1 сменился родитель (M3 → M4), значит это уже другой объект F1'. Раз сменился хэш F1, сменился и родитель F2, значит F2 тоже новый. `range-diff` показывает, что сами изменения при этом одинаковые (`=`). Старые F1/F2 никуда не делись: они видны в `git reflog ex01/feature`.

</details>

**Начать заново:**

```bash
git switch ex01/feature
git reset --hard origin/ex01/feature
git switch ex01/main
git reset --hard origin/ex01/main
```
