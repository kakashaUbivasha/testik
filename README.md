# 8. force-with-lease

**Ветка:** `ex08/start`. Два коммита, которыми засеваем «удалённый» репозиторий. В `greeting.txt` опечатка `Helo`: «я» буду исправлять её через amend.

Упражнение локальное: bare-репозиторий и два клона создаются рядом с папкой песочницы. Команды выполняй из клона песочницы (например, `D:/git-sandbox`). Пути относительные и работают и в PowerShell, и в Git Bash.

## Подготовка

```bash
git init --bare -b main ../fwl/remote.git
git push ../fwl/remote.git origin/ex08/start:refs/heads/main
cd ../fwl
git clone remote.git me
git clone remote.git colleague
git -C colleague config user.name "Colleague"
```

`-b main` нужен потому, что у тебя `init.defaultBranch = master`. Без него HEAD bare-репо смотрел бы на несуществующий `master`, и клоны остались бы без checkout.

## Задание

1. Коллега пушит коммит.
2. У себя сделай amend и `git push --force-with-lease`: должен быть отказ.
3. Сделай `git fetch` и повтори: пуш пройдёт, а коммит коллеги сотрётся.
4. Повтори сценарий с `--force-if-includes`.

<details>
<summary>Решение</summary>

### Раунд 1: `--force-with-lease`

```bash
cd colleague
# создай colleague.txt с любым текстом
git add colleague.txt
git commit -m "colleague: add colleague.txt"
git push

cd ../me
# исправь Helo -> Hello в greeting.txt
git commit -a --amend --no-edit
git push                       # ! [rejected] main -> main (fetch first)
git push --force-with-lease    # ! [rejected] main -> main (stale info)
```

`--force-with-lease` перезаписывает ветку на сервере, только если она там совпадает с твоей `origin/main`. Ты не видел коммит коллеги, твоя `origin/main` устарела, поэтому отказ.

```bash
git fetch                      # origin/main = коммит коллеги
git push --force-with-lease    # + ... main -> main (forced update)
git log --oneline origin/main  # коммита коллеги больше нет
```

Lease проверяет только «знаю ли я, что сейчас на сервере», а не «включил ли я это в свою ветку». После любого `fetch` (руками, в IDE, фоном) проверка проходит, и чужая работа затирается.

### Раунд 2: `--force-if-includes`

Коллега подтягивает переписанную историю (его старый коммит потерян) и пушит новый:

```bash
cd ../colleague
git fetch
git reset --hard origin/main
# создай colleague2.txt
git add colleague2.txt
git commit -m "colleague: add colleague2.txt"
git push
```

Я снова переписываю свой коммит, и IDE «случайно» делает fetch:

```bash
cd ../me
# допиши в greeting.txt вторую строку
git commit -a --amend --no-edit
git fetch
git push --force-with-lease --force-if-includes
# ! [rejected] main -> main (remote ref updated since checkout)
```

`--force-if-includes` дополнительно проверяет, что текущий `origin/main` (коммит коллеги) встречается в reflog твоей локальной ветки, то есть ты его действительно включал в свою работу. Ты его только скачал, поэтому отказ. Обычный `--force-with-lease` в этой же ситуации прошёл бы.

Как правильно: сначала включить коммит коллеги, потом пушить.

```bash
git pull --rebase
# конфликт в greeting.txt: столкнулись старая и новая версии твоего же коммита.
# Оставь нужный текст (Hello, world! + вторая строка)
git add greeting.txt
git rebase --continue
git push                       # fast-forward, коммит коллеги цел
git log --oneline --graph
```

Чтобы не писать флаги каждый раз: `git config --global alias.pushf "push --force-with-lease --force-if-includes"`.

</details>

**Начать заново:** удали папку `../fwl` и повтори подготовку.
