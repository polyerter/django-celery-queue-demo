from celery import shared_task


@shared_task
def calculate(a, b):
    return a + b
