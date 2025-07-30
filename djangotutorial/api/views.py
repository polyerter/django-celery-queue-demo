from django.http import HttpResponse

from app.celery import prepare_video


def index(request):
    context = {}

    prepare_video.apply_async()

    print('context')

    return HttpResponse()
