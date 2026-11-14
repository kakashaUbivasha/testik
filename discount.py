from limits import MAX_DISCOUNT


def apply_discount(price, percent):
    percent = min(percent, MAX_DISCOUNT)
    return price - price * percent // 100
