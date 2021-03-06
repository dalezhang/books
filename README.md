# tables
* users
  * amount
  * frezze_amount
  * name
* books
  * count
  * name
* books_transactions
  * user_id
  * book_id
  * parent_id (out transction id)
  * created_at
  * from_count
  * to_count
  * option (out: 1, back: 2)
  * status (no_returned: 0, returned: 1)
* user_amount_transactions
  * user_id
  * books_transaction_id
  * from_amount
  * to_amount
  * option (borrow_book: 1, recharge: 2)

# API
### users
##### create
* Create a user with name and email, new user will have 1000 amount.
```
POST /v1/users?name=dale&email=example@mail.com HTTP/1.1
Host: 0.0.0.0:3000
Content-Type: application/json
Content-Length: 82

{
    "users": {
        "name": "dale",
        "email": "example@qq.com"
    }
}

```
##### show
* Query user profile by user id.
* List borrow book records which not returned yet.
* List amount change records include borrow books cost and recharge.
```
GET /v1/users/1 HTTP/1.1
Host: 0.0.0.0:3000
```
```
{
    "id": 1,
    "amount": 997,
    "name": "dale",
    "email": "example@qq.com",
    "unreturnd_books_transactions": [
        {
            "id": 7,
            "from_count": 7,
            "to_count": 6,
            "option": "out",
            "created_at": "2021-05-10T10:06:57.537Z",
            "updated_at": "2021-05-10T10:06:57.537Z",
            "status": "no_returned",
            "parent_id": null,
            "book_id": 1
        },
        {
            "id": 8,
            "from_count": 6,
            "to_count": 5,
            "option": "out",
            "created_at": "2021-05-10T10:08:02.489Z",
            "updated_at": "2021-05-10T10:08:02.489Z",
            "status": "no_returned",
            "parent_id": null,
            "book_id": 1
        }
    ],
    "user_amount_transactions": [
        {
            "id": 1,
            "user_id": 1,
            "books_transaction_id": 3,
            "from_amount": 1000,
            "to_amount": 999,
            "option": "borrow_book",
            "created_at": "2021-05-10T08:58:22.423Z",
            "updated_at": "2021-05-10T08:58:22.423Z",
            "amount": 0
        },
        {
            "id": 2,
            "user_id": 1,
            "books_transaction_id": 5,
            "from_amount": 999,
            "to_amount": 998,
            "option": "borrow_book",
            "created_at": "2021-05-10T09:32:44.370Z",
            "updated_at": "2021-05-10T09:32:44.370Z",
            "amount": 1
        },
        {
            "id": 3,
            "user_id": 1,
            "books_transaction_id": 9,
            "from_amount": 998,
            "to_amount": 997,
            "option": "borrow_book",
            "created_at": "2021-05-10T10:08:08.675Z",
            "updated_at": "2021-05-10T10:08:08.675Z",
            "amount": 1
        }
    ]
}
```
##### borrow_book
* Borrow a book with user_id and book_id.
* Can't borrow a book if user's amount less than 1.
```
POST /v1/users/1/borrow_book?book_id=1 HTTP/1.1
Host: 0.0.0.0:3000
```
```
{
    "id": 4,
    "from_count": 8,
    "to_count": 7,
    "option": "out",
    "created_at": "2021-05-10T09:07:46.700Z",
    "updated_at": "2021-05-10T09:07:46.700Z",
    "status": "no_returned",
    "parent_id": null,
    "book": {
        "count": 7,
        "id": 1,
        "name": "Bloody Mutant",
        "total_income": 1,
        "created_at": "2021-05-10T08:24:11.541Z",
        "updated_at": "2021-05-10T09:07:46.701Z"
    },
    "user": {
        "id": 1,
        "amount": 999,
        "name": "dale",
        "email": "example@qq.com"
    }
}
```
##### return_books
* Return a book whith user_id and book_id and cost.
* If user's amount is less than the cost, a error message will be return.
* If this book already been returned, a error message will be return.
* if user's amount is not emough to pay, please recharge first.
```
POST /v1/users/1/return_book?book_id=1 HTTP/1.1
Host: 0.0.0.0:3000
Content-Type: application/json
Content-Length: 35

{
    "book_id": 1,
    "cost": 3
}
```
```
{
    "id": 12,
    "from_count": 6,
    "to_count": 7,
    "option": "back",
    "created_at": "2021-05-11T06:11:41.387Z",
    "updated_at": "2021-05-11T06:11:41.387Z",
    "status": "returned",
    "parent_id": 8,
    "book_id": 1,
    "book": {
        "count": 7,
        "id": 1,
        "total_income": 9,
        "name": "Bloody Mutant",
        "created_at": "2021-05-10T08:24:11.541Z",
        "updated_at": "2021-05-11T06:11:41.417Z"
    },
    "user": {
        "id": 1,
        "amount": 1190,
        "name": "dale",
        "email": "example@qq.com"
    },
    "user_amount_transaction": {
        "id": 6,
        "user_id": 1,
        "books_transaction_id": 12,
        "from_amount": 1193,
        "to_amount": 1190,
        "option": "borrow_book",
        "created_at": "2021-05-11T06:11:41.408Z",
        "updated_at": "2021-05-11T06:11:41.408Z",
        "amount": 3
    }
}
# already returned
{
    "base": [
        "book 1 is already return"
    ]
}
```
##### recharge
* Recharge to a user with some amount.
* Require user id and amount.
* A user_amount_transaction will be created and return.
```
POST /v1/users/1/recharge?amount=100 HTTP/1.1
Host: 0.0.0.0:3000
Content-Type: application/json
Content-Length: 21

{
    "amount": 100
}
```
```
{
    "id": 4,
    "user_id": 1,
    "books_transaction_id": null,
    "from_amount": 1096,
    "to_amount": 1196,
    "option": "recharge",
    "created_at": "2021-05-11T06:09:11.196Z",
    "updated_at": "2021-05-11T06:09:11.196Z",
    "amount": 100
}
```
### books
##### index
* List all books.
```
GET /v1/books HTTP/1.1
Host: 0.0.0.0:3000
```
##### show
* Query one book by id.
```
GET /v1/books/1 HTTP/1.1
Host: 0.0.0.0:3000
```

```
{
    "id": 1,
    "amount": 998,
    "name": "dale",
    "email": "example@qq.com",
    "unreturnd_books": [],
    "user_amount_transactions": [
        {
            "id": 1,
            "user_id": 1,
            "books_transaction_id": 3,
            "from_amount": 1000,
            "to_amount": 999,
            "option": "borrow_book",
            "created_at": "2021-05-10T08:58:22.423Z",
            "updated_at": "2021-05-10T08:58:22.423Z",
            "amount": 0
        },
        {
            "id": 2,
            "user_id": 1,
            "books_transaction_id": 5,
            "from_amount": 999,
            "to_amount": 998,
            "option": "borrow_book",
            "created_at": "2021-05-10T09:32:44.370Z",
            "updated_at": "2021-05-10T09:32:44.370Z",
            "amount": 1
        }
    ]
}
```
##### income
* Show total_income of a book, query by id and time range.
* If time range is not given, this api will return total_income for last
  1 day.
```
GET /v1/books/1/income?from=2021-05-01&to=2021-05-11 HTTP/1.1
Host: 0.0.0.0:3000
```
```
{
    "book_id": "1",
    "from": "2021-05-01T00:00:00.000+08:00",
    "to": "2021-05-11T23:59:59.999+08:00",
    "total_income": 1
}
```
