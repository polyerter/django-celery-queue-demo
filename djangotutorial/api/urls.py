from django.urls import path

from api.views import index

urlpatterns = [
    path('v1/test', index, name='test'),
]
