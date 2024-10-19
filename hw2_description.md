# Описание домашнего задания №2 по Git  

1. Создайте репозиторий **git_branches**
2. В репозитории создайте файл *factorial.py*
3. Сохраните и закомитьтесь.
4. Создайте новую ветку ***recursive*** но пока не переходите на неё
5. Вставьте в файл *factorial.py* следующий код:
```
def factorial(n, method="iterative"):
    if method == "iterative":
        result = 1
        for i in range(1, n + 1):
            result *= i
        return result
    else:
        # Placeholder for recursive method
        pass

if __name__ == "__main__":
    number = 5
    method = input("Choose method (iterative/recursive): ").strip().lower()
    print(f"Factorial of {number} is {factorial(number, method)}")
```
6. Сохраните изменения и закомитьте
7. Перейдите на ветку ***recursive***
8. Вставьте в файл следующий код:
```
def factorial(n, method="iterative"):
    if method == "recursive":
        if n == 0 or n == 1:
            return 1
        else:
            return n * factorial(n - 1, method="recursive")
    else:
        # Placeholder for iterative method
        pass

if __name__ == "__main__":
    number = 5
    method = input("Choose method (iterative/recursive): ").strip().lower()
    print(f"Factorial of {number} is {factorial(number, method)}")
```
9. Сохраните изменения и закомитьте
10. Вернитесь на ветку ***main***
11. Произведите слияние основной ветки с веткой ***recursive***
12. Разрешите возникший конфликт (подсказка - этот конфликт вам придётся решать вручную)
13. Закомитьте результат `но не удаляйте` ветку ***recursive***
14. Перенесите репозиторий `с обеими ветками` на github сделав его публичным
15. Прикрепите ссылку на этот репозиторий.