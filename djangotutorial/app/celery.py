import os
from time import sleep

from celery import Celery

# Set the default Django settings module for the 'celery' program.
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings')

app = Celery('app')

# Using a string here means the worker doesn't have to serialize
# the configuration object to child processes.
# - namespace='CELERY' means all celery-related configuration keys
#   should have a `CELERY_` prefix.
app.config_from_object('django.conf:settings', namespace='CELERY')

# Load task modules from all registered Django apps.
app.autodiscover_tasks()


@app.task
def prepare_video():
    # print(f'Request: {self.request!r}')
    sleep(10)
    print(f'Request')

    subtitle_task.apply_async()

    return 'prepare_video'

@app.task
def subtitle_task():
    print('start[test_1]')
    sleep(5)

    return 'subtitle_task'