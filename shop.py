from discount import apply_discount


def total(prices):
    return sum(prices)


if __name__ == "__main__":
    print("Total:", apply_discount(total([100, 200, 300]), 10))
