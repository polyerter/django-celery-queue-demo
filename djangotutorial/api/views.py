from django.http import HttpResponse

from app.celery import debug_task


def index(request):
    context = {}

    debug_task.delay()

    print('context')

    return HttpResponse()
