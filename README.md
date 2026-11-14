# 5. Потерянный индекс

**Ветка:** `ex05/lost-index`, в ней файл `notes.txt`.

## Задание

Измени `notes.txt`, сделай `git add`, затем `git reset --hard`. Верни содержимое через `git fsck --lost-found`.

<details>
<summary>Решение</summary>

```bash
git switch ex05/lost-index
# допиши в notes.txt любую строку (редактором)
git add notes.txt
git reset --hard              # правка пропала и из индекса, и с диска
git fsck --lost-found
# dangling blob 3f2a9c...      <- это твоя версия notes.txt
git show 3f2a9c               # убедись, что это она
cp .git/lost-found/other/3f2a9c<полный хэш> notes.txt
git diff                      # правка вернулась
```

`git add` записывает содержимое файла в базу объектов (blob) и кладёт ссылку на него в индекс. `reset --hard` выбрасывает ссылку из индекса, а blob остаётся «висячим» (dangling). `fsck` его находит, а с `--lost-found` ещё и сохраняет копию в `.git/lost-found/other/`.

Если бы ты **не** сделал `git add`, правку вернуть было бы нельзя: в git она никогда не попадала.

Висячих объектов может быть несколько (например, после других упражнений): проверь каждый через `git show <хэш>`.

`cp` работает и в Git Bash, и в PowerShell. А `git show <хэш> > notes.txt` в PowerShell 5.1 запишет файл в другой кодировке, так не делай.

</details>

**Начать заново:**

```bash
git reset --hard origin/ex05/lost-index
```
