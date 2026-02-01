#!/bin/bash

# 1. Получаем список локальных веток
echo "Available branches:"
branches=($(git branch --format="%(refname:short)"))

# 2. Выводим меню выбора
PS3="Select branch number (or press Ctrl+C to exit): "
select branch in "${branches[@]}"; do
    if [ -n "$branch" ]; then
        echo "Selected branch: $branch"
        break
    else
        echo "Invalid selection."
    fi
done

# 3. Переключаемся на ветку
git checkout "$branch"

# 4. Запрашиваем текст коммита
read -p "Enter commit message: " msg

# 5. Выполняем команды
git add .
git commit -m "$msg"
git push origin "$branch"

echo "Done!"