# 7. Revert merge

**Ветки:** `ex07/main`, `ex07/feature`

```
* F2: shop: use discount at checkout   <- ex07/feature
* F1: add apply_discount()
* C2: ignore __pycache__               <- ex07/main
* C1: init shop
```

`ex07/main` стоит прямо на базе фичи, поэтому обычный merge был бы fast-forward. Нужен `--no-ff`, чтобы появился merge-коммит.

Фича «скидка» сломана: `discount.py` импортирует модуль `limits`, которого нет. `python shop.py` падает с `ModuleNotFoundError: No module named 'limits'`.

## Задание

1. Влей `ex07/feature` в `ex07/main` с `--no-ff`.
2. Отмени merge: `git revert -m 1 <merge>`.
3. Добавь в `ex07/feature` исправление: файл `limits.py` с одной строкой `MAX_DISCOUNT = 30`. Влей ветку снова.
4. Убедись, что старые изменения (F1, F2) **не вернулись**.
5. Почини через revert реверта.

<details>
<summary>Решение</summary>

```bash
git switch ex07/feature
git switch ex07/main
git merge --no-ff ex07/feature -m "Merge discount feature"
python shop.py                 # ModuleNotFoundError: сломано

git revert -m 1 --no-edit HEAD # -m 1: основная линия = первый родитель (main)
ls                             # discount.py исчез, shop.py снова без скидки
```

Исправление в ветке фичи:

```bash
git switch ex07/feature
# создай limits.py со строкой MAX_DISCOUNT = 30
git add limits.py
git commit -m "F3: add limits.py"
git switch ex07/main
git merge --no-ff ex07/feature -m "Merge discount fix"
ls                             # появился limits.py, а discount.py НЕТ
git show --stat HEAD           # merge принёс только limits.py
python shop.py                 # Total: 600, скидки нет
```

Почему так: после первого merge коммиты F1 и F2 уже входят в историю main. Revert откатил их **содержимое**, но не историю. При втором merge база слияния уже F2, поэтому git приносит только то, что появилось после F2, то есть F3.

Починка: отменяем сам revert.

```bash
git log --oneline              # найди хэш: Revert "Merge discount feature"
git revert --no-edit <хэш>
ls                             # discount.py вернулся
python shop.py                 # Total: 540
git log --graph --oneline
```

</details>

**Начать заново:**

```bash
git switch ex07/feature
git reset --hard origin/ex07/feature
git switch ex07/main
git reset --hard origin/ex07/main
```
